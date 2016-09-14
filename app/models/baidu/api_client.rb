class Baidu::ApiClient
  APPS_URL = 'http://m.baidu.com/appsrv'
  #SEARCH_URL = 'http://m.baidu.com/s'
  SEARCH_URL = 'http://m.baidu.com/as'

   # get :app, docid: 123
  def get resource, options={}
    method_name = "get_#{resource}".to_sym
    if respond_to? method_name
      make_api_call(method_name, options)
    else
      raise NotImplementedError
    end
  end

  #TODO: add new api methods
  #      generate uid by ruby

  def get_app options
    make_request :get, APPS_URL, ::Baidu::DefaultParams.detail, options, [:docid]
  end

  def get_comments options
    make_request :get, APPS_URL, ::Baidu::DefaultParams.comments, options, [:docid, :groupid, :start, :count]
  end

  def get_search options
    make_request :get, SEARCH_URL, ::Baidu::DefaultParams.search, options, [:word, :pn]
  end

  def get_board options
    make_request :get, APPS_URL, ::Baidu::DefaultParams.board, options, [:boardid, :sorttype, :pn]
  end

  def get_boards options
    make_request :get, APPS_URL, ::Baidu::DefaultParams.boards, options, [:sorttype]
  end

  # action (risingrank|ranktoplist)
  # rising and top ranks
  def get_ranks options
    make_request :get, APPS_URL, ::Baidu::DefaultParams.ranks, options, [:action, :pn]
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

  def make_request request_type, url, default_params, options, required_options
    params = default_params
    required_options.each {|key| params[key.to_s] = get_option(options, key) }
    response = connection(url).send(request_type) {|request| request.params = params }
    JSON.parse(response.body)
  end

  #Faraday::ConnectionFailed:
  #     execution expired

  # JSON::ParserError

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
