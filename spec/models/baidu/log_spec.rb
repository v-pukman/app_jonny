require 'rails_helper'

RSpec.describe Baidu::Log do
  describe ".error" do
    before do
      Baidu::Log.error 'Baidu::App', 'save', StandardError.new
    end
    let(:log) { Log.last }
    it { expect(log.area).to eq Log::BAIDU_AREA }
    it { expect(log.level).to eq Log::ERROR_LEVEL }
  end
end
