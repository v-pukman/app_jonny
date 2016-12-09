require 'rails_helper'

RSpec.describe Log, type: :model do

  let(:level) { Log::ERROR_LEVEL }
  let(:area) { Log::BAIDU_AREA }
  let(:class_name) { "Baidu::Service::App" }
  let(:method_name) { "download_app" }
  let(:context) do
    { "docid" => 100 }
  end

  it "has a factory" do
    log = create :log
    expect(log.persisted?).to eq true
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
    it { expect(log.message).to include error.message }
    it { expect(log.message).to include error.class.to_s }
    it { expect(log.backtrace).to eq error.backtrace.join("\n") }
  end

  describe ".info" do
    let(:message) { 'task is running' }
    before do
      Log.info area, class_name, method_name, message, context
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq Log::INFO_LEVEL }
    it { expect(log.message).to include message }
    it { expect(log.backtrace).to eq nil }
  end

  describe ".clear" do
    before do
      Log.destroy_all
      create_list :log, 5, area: Log::BAIDU_AREA
      create_list :log, 10, area: 'any other'
      expect(Log.count).to eq 15
    end
    it "delete logs with passed params" do
      Log.clear area: Log::BAIDU_AREA
      expect(Log.where(area: Log::BAIDU_AREA).count).to eq 0
      expect(Log.where(area: 'any other').count).to eq 10
    end
  end
end
