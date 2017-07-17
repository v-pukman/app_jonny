require 'log'

class Baidu::UpdateAppsWorker
  include Sidekiq::Worker

  #TODO: tests!
  def perform app_ids
    ::TaskMailer.status_report(TaskMailer::STARTED, "perform_Worker_Method", "app_ids count: #{app_ids.count}, app_ids: #{app_ids}").deliver_now

    ::Log.info ::Log::BAIDU_AREA, self.class, :perform, 'run apps updater', { apps_count: app_ids.count }
    service = ::Baidu::Service::App.new
    app_ids.each do |app_id|
      begin
        service.update_app app_id
      rescue Exception => e
        ::TaskMailer.status_report(TaskMailer::FAILED, "perform_Worker_Method", "app_id #{app_id}, #{e.message}").deliver_now
      end
    end

    ::TaskMailer.status_report(TaskMailer::COMPLETED, "perform_Worker_Method", "app_ids count: #{app_ids.count}, app_ids: #{app_ids}").deliver_now
  end
end
