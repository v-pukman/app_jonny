class Baidu::UpdateAppsWorker
  include Sidekiq::Worker

  #TODO: tests!
  def perform app_ids
    ::Baidu::Log.info self.class, :perform, 'run apps updater', { apps_count: app_ids.count }
    service = ::Baidu::Service::App.new
    app_ids.each do |app_id|
      service.update_app app_id
    end
  end
end
