require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "#task_report" do
    let(:params) do
      {
        task_status: AdminMailer::STARTED,
        task_name: 'task:downloading',
        details: ['found 100', 'saved 90']
      }
    end
    let(:report) { AdminMailer.task_report(*params.values).deliver_now }

    it { expect(report.subject).to eq "Task #{params[:task_status]}" }
    it { expect(report.to).to eq ['pukman.victor@gmail.com'] }
    it { expect(report.body.encoded).to match params[:task_name] }

    it "renders details from array" do
      params[:details].each do |d|
        expect(report.body.encoded).to match d
      end
    end
  end
end
