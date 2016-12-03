class Baidu::Service::Base
  def api
    @api ||= Baidu::Service::ApiClient.new
  end
end
