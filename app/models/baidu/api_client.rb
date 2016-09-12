class Baidu::ApiClient
  APPS_URL = 'http://m.baidu.com/appsrv'
  SEARCH_URL = 'http://m.baidu.com/s'

   # get :app, docid: 123
  def get resource, options={}
    method_name = "get_#{resource}".to_sym
    if respond_to? method_name
      make_api_call(method_name, options)
    else
      raise NotImplementedError
    end
  end

  #TODO: add common response handler
  #      add new api methods
  #      generate uid by ruby
  def get_app options
    params = ::Baidu::DefaultParams.detail.merge({
      'docid' => get_option(options, :docid)
    })
    response = connection(APPS_URL).get do |request|
      request.params = params
    end
    JSON.parse(response.body)
  end

  private

  def connection api_url
    options = {
      url: api_url,
      ssl:  { verify: false }
    }
    Faraday.new(options) do |faraday|
      faraday.headers['Host'] = 'm.baidu.com'
      faraday.headers['Connection'] = 'Keep-Alive'
      faraday.headers['User-Agent'] = 'Apache-HttpClient/UNAVAILABLE (java 1.4)'
      faraday.headers['Pragma'] = 'no-cache'
      faraday.headers['Cache-Control'] = 'no-cache'
      faraday.options[:timeout] = 30
      faraday.options[:open_timeout] = 15
      faraday.adapter Faraday.default_adapter
    end
  end

  # do we need it for baidu?
  def handle_timeouts
    begin
      yield
    rescue Faraday::TimeoutError
      {}
    end
  end

  def handle_caching method_name, options
    if cached = RedisClient.get(cache_key(method_name, options))
      JSON.parse(cached)
    else
      yield.tap do |results|
        RedisClient.setex(cache_key(method_name, options), 24.hour.to_i, results.to_json)
      end
    end
  end

  def cache_key method_name, options
    "baidu_client:#{method_name}:#{options}"
  end

  def make_api_call method_name, options
    handle_timeouts do
      handle_caching(method_name, options) do
        send(method_name, options)
      end
    end
  end

  def get_option options, key
    raise ArgumentError, "option :#{key} not found" unless options.keys.include?(key)
    options[key]
  end
end
