class Baidu::ApiClient
  APPS_URL = 'http://m.baidu.com/appsrv'
  SEARCH_URL = 'http://m.baidu.com/s'

  # docid id versionid of app
  def get_app docid
    params = default_params
    headers = default_headers
    params['docid'] = docid
    make_request APPS_URL, headers, params
  end

  def make_request url, headers, params
    agent = Mechanize.new
    res = agent.get(url, params, nil, headers)
    JSON.parse res.body
  end

  #TODO: try with faraday

  private

  def default_headers
    {
      'Host' => 'm.baidu.com',
      'Connection' => 'Keep-Alive',
      'User-Agent' => 'Apache-HttpClient/UNAVAILABLE (java 1.4)',
      'Pragma' => 'no-cache',
      'Cache-Control' => 'no-cache',
    }
  end

  def default_params
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
