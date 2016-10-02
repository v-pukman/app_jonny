require 'rails_helper'

RSpec.describe Log, type: :model do
  let(:error) { StandardError.new "error message here" }
  let(:level) { Log::ERROR_LEVEL }
  let(:area) { Log::BAIDU_AREA }
  let(:class_name) { "Baidu::Service::App" }
  let(:method_name) { "download_app" }
  let(:context) do
    { "docid" => 100 }
  end
  before do
    error.set_backtrace(["row1", "row2"])
  end

  describe ".write" do
    before do
      Log.write(level, area, class_name, method_name, error, context)
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq level }
    it { expect(log.area).to eq area }
    it { expect(log.class_name).to eq class_name }
    it { expect(log.method_name).to eq method_name }
    it { expect(log.context).to eq context }
    it { expect(log.message).to eq error.message }
    it { expect(log.backtrace).to eq error.backtrace.join("\n") }
  end

  describe ".error" do
    before do
      Log.error area, class_name, method_name, error, context
    end
    let(:log) { Log.last }
    it { expect(log.level).to eq Log::ERROR_LEVEL }
  end
end
