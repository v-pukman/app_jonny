class Baidu::Service::Base
  def api
    @api ||= Baidu::ApiClient.new
  end
end
