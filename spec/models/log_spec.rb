require 'rails_helper'

RSpec.describe Log, type: :model do

  let(:level) { Log::ERROR_LEVEL }
  let(:area) { Log::BAIDU_AREA }
  let(:class_name) { "Baidu::Service::App" }
  let(:method_name) { "download_app" }
  let(:context) do
    { "docid" => 100 }
  end


  describe ".write" do
    let(:message) { 'bang!' }
    let(:backtrace) { '1: raising bang!' }
    before do
      Log.write(level, area, class_name, method_name, message, backtrace, context)
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq level }
    it { expect(log.area).to eq area }
    it { expect(log.class_name).to eq class_name }
    it { expect(log.method_name).to eq method_name }
    it { expect(log.context).to eq context }
    it { expect(log.message).to eq message}
    it { expect(log.backtrace).to eq backtrace }
  end

  describe ".error" do
    let(:error) { StandardError.new "error message here" }
    before do
      error.set_backtrace(["row1", "row2"])
      Log.error area, class_name, method_name, error, context
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq Log::ERROR_LEVEL }
    it { expect(log.message).to eq error.message }
    it { expect(log.backtrace).to eq error.backtrace.join("\n") }
  end

  describe ".info" do
    let(:message) { 'task is running' }
    before do
      Log.info area, class_name, method_name, message, context
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq Log::INFO_LEVEL }
    it { expect(log.message).to eq message }
    it { expect(log.backtrace).to eq nil }
  end
end
