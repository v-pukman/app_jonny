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

  #TODO: generate uid by ruby

  # returns app full info
  ## docid
  def get_app options
    make_request :get, APPS_URL, :details, options, [:docid]
  end

  # returns comments of app
  ## docid
  ## groupid
  ## start (0..any)
  ## count (10..3000)
  def get_comments options
    make_request :get, APPS_URL, :comments, options, [:docid, :groupid, :start, :count]
  end

  # returns search results (apps preview list)
  ## word
  ## pn (page number)
  def get_search options
    make_request :get, SEARCH_URL, :search, options, [:word, :pn]
  end

  # returns apps in this board
  ## boardid
  ## pn (0..any)
  ## sorttype (game|soft)
  ## action (generalboard|featureboard) # dafault - generalboard
  def get_board options
    make_request :get, APPS_URL, :board, options, [:boardid, :sorttype, :pn]
  end

  # returns boards of games or apps
  ## sorttype (soft|game)
  ## pn (default 0, seems there is only one page)
  def get_boards options
    make_request :get, APPS_URL, :boards, options, [:sorttype]
  end

  # returns rising and top ranks (games and apps)
  ## action (risingrank|ranktoplist)
  ## pn (page number 0...any)
  def get_ranks options
    make_request :get, APPS_URL, :ranks, options, [:action, :pn]
  end

  # returns page with featured boards and common featured apps list
  # from this page we can load: 1. featured boards 2. common featured ranks
  ## pn (0..any)
  def get_featured options
    make_request :get, APPS_URL, :featured, options, [:pn]
  end

  # returns main page with boards list or ranked games in the board
  ## pn (0..any)
  ## board_id (not required, if passed - returns ranked games in this board)
  def get_game_ranks options
    make_request :get, APPS_URL, :game_ranks, options, [:pn]
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

  def make_request request_type, url, default_params_name, options, required_options
    params = default_params default_params_name
    custom_options = options.select{|key,_| !required_options.include?(key) }

    required_options.each {|key| params[key.to_s] = get_option(options, key) }
    custom_options.each {|key, value| params[key.to_s] = value }

    response = connection(url).send(request_type) {|request| request.params = params }
    JSON.parse(response.body)
  end

  def original_default_params default_params_name
    ::Baidu::DefaultParams.send(default_params_name)
  end

  def default_params default_params_name
    params = original_default_params default_params_name

    original_uid = params['uid']
    new_uid = generate_uid 69
    new_pu = params['pu'].split(',').map {|p| p.include?('cuid@') ? "cuid@#{new_uid[0...42]}#{generate_uid(31)}" : p }.join(',')

    params['uid'] = new_uid
    params['pu'] = new_pu

    params
  end

  def generate_uid length
    SecureRandom.urlsafe_base64(length)[0...length]
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
