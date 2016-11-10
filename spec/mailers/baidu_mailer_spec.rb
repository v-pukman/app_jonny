require "rails_helper"

RSpec.describe BaiduMailer, type: :mailer do
  let(:date) { Date.yesterday }
  describe ".log_report" do
    let!(:error_log) { create :log, area: Log::BAIDU_AREA, level: Log::ERROR_LEVEL, created_at: date, message: 'Oh, boy!' }
    let!(:info_log) { create :log, area: Log::BAIDU_AREA, level: Log::INFO_LEVEL, created_at: date, message: 'Super!' }
    let(:report) { BaiduMailer.log_report.deliver_now }
    it { expect(report.body.encoded).to match error_log.message }
    it { expect(report.body.encoded).to match info_log.message }
  end
end
