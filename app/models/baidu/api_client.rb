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
  def get_app options
    params = detail_params.merge({
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

  ####################
  ## DEFAULT PARAMS ##
  ####################

  # docid
  def detail_params
    {
      'uid' => '082YulO6SilQuBig_PvOigPz2ilqiBajYi2U80iuHiqduSivguvsigPS28gfuB85QSIoC',
      'native_api' => 1,
      'psize'  => 0,
      'abi'  =>'armeabi-v7a',
      'cll'  =>'gasy8gayvfjCRvuE_a2BNgaOvtQlm5TuB',
      'usertype'  => 1,
      'is_support_webp'  => true,
      'ver'  =>16785257,
      'from'   =>'1012271a',
      'cct'  =>'qivtkjuhVfjgRS8I68v3kYuteug_MHaGq8BgklutVujTM-8OA',
      'pc_channel' => '',
      'operator' => '',
      'network'  => 'WF',
      'pkname'  => 'com.baidu.appsearch',
      'country' => 'RU',
      'cen' => 'cuid_cut_cua_uid',
      'gms' => true,
      'platform_version_id' => 15,
      'firstdoc' => '',
      'action' =>  'detail',
      'pu'  => 'cua@_Pvjh_aJvCI-JEjPkJAiC_CX2Ig-N28OAy2OB,osname@baiduappsearch,ctv@1,cfrom@1012271a,cuid@082YulO6SilQuBig_PvOigPz2ilqiBajYi2U80iuHi6ZuviJluvwigaxvf_lav8Kjuv7iou5B,cut@p8D_O09bXu5dfQNdpa2H8jIJ2I_DCvheguLJjkJRm6LX5SZeB',
      'language'  => 'ru',
      'apn' => '',
      'native_api'  =>  1,
      'docid'  => '',
      'f'  => 'gamepagecolumns@人气网游火力全开@2@15@source+NATURAL@boardid+12690@pos+15@searchid+191596714211469762@terminal_type+client@sample+adv'
    }
  end
end
