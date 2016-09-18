class Baidu::Service
  attr_reader :api
  def initialize
    @api = Baidu::ApiClient.new
  end

  # preview_info example - fixtures/static/baidu/preview_info_source
  def save_from_preview_info preview_info, additional_data={}
    preview_info = JSON.parse(preview_info.to_json)
    full_info = nil
    itemdata = preview_info['itemdata']
    if itemdata.nil? || !itemdata.is_a?(Hash) || itemdata['docid'].nil?
      return nil
    end

    id_str = Baidu::App.build_id_str(itemdata['type'], itemdata['packageid'], itemdata['groupid'], itemdata['docid'])
    app = Baidu::App.where(id_str: id_str).first
    if app.nil?
      full_info = api.get :app, docid: itemdata['docid']
      # will check for second time
      # because sometimes preview info doesnt have all id
      # also it handles db record dublication error
      app = create_or_update build_app_attrs(full_info)
    end

    #save_game_day(app.id, preview_info, full_info, search_position, in_board_position)

    # additional_data
    # developer

    # 1. versions
    # 2. permition type
    # 3. permission guide
    # 4. tags
    # 5. game tags
    # 6. video ?
    # 7. deloper ?
    # 8. category ?
    app
  end

  def create_or_update attrs
    id_str = Baidu::App.build_id_str(attrs['app_type'], attrs['packageid'], attrs['groupid'], attrs['docid'])
    app = Baidu::App.where(id_str: id_str).first
    if app.nil?
      app = Baidu::App.new(attrs)
      app.save!
    else
      app.update_attributes(attrs)
    end
    app
  rescue ActiveRecord::RecordNotUnique
    app = Baidu::App.where(id_str: id_str).first
    app.update_attributes(attrs)
    app
  end

  #TODO: tests!
  def fetch_base_info full_info
    JSON.parse(full_info.to_json)['result']['data']['base_info']
  end

  #TODO: tests!
  def build_app_attrs full_info
    data = fetch_base_info full_info
    full_data = fetch_base_info full_info #pointer fix

    attrs = data.keep_if {|a| Baidu::App.column_names.include?(a.to_s)}
    attrs['today_str_download'] = full_data['today_strDownload']
    attrs['now_download'] = full_data['nowDownload']
    attrs['app_type'] = full_data['type']

    #attrs['search_position'] = search_position if search_position
    #attrs['in_board_position'] = in_board_position if in_board_position
    #attrs['baidu_game_board_id'] = additional_data[:baidu_game_board_id] if additional_data[:baidu_game_board_id]
    #attrs['q_app_id'] = additional_data[:q_app_id] if additional_data[:q_app_id]
    #attrs['rank_position'] = additional_data[:rank_position] if additional_data[:rank_position]

    #if full_data['dev_display']
    #  attrs['dev_id'] = full_data['dev_display']['dev_id']
    #  attrs['dev_name'] = full_data['dev_display']['dev_name']
    #  attrs['dev_score'] = full_data['dev_display']['dev_score']
    #  attrs['dev_level'] = full_data['dev_display']['dev_level']
    #end

    attrs
  end

  def fetch_versions_info full_info
    base_info = fetch_base_info(full_info)
    #1. get list
    versions = base_info['app_moreversion']
    #2. add current varsion
    curr_version = {
      "version" => base_info['versionname'],
      "content": [{
        "packageid": base_info['packageid'],
        "groupid": base_info['groupid'],
        "docid": base_info['docid'],
        "sname": base_info['sname'],
        "size": base_info['size'],
        "updatetime": base_info['updatetime'],
        "versioncode": base_info['versioncode'],
        "sourcename": base_info['sourcename'],
        "type": base_info['type'],
        "all_download_pid": base_info['all_download_pid'],
        "strDownload": base_info['strDownload'],
        "display_score": base_info['display_score'],
        "all_download": base_info['all_download']
      }],
      "versioncode": base_info['versioncode']
    }
    versions << curr_version.deep_stringify_keys
    versions
  end

  def build_versions_attrs full_info
    versions = fetch_versions_info(full_info)
    attrs = []
    versions.each do |version|
      version['content'].each do |version_content|
        # type -> app_type
        # strDownload -> str_download
        attrs << {
          name: version['version'],
          code: version_content['versioncode'],
          packageid: version_content['packageid'],
          groupid: version_content['groupid'],
          docid: version_content['docid'],
          sname: version_content['sname'],
          size: version_content['size'],
          updatetime: version_content['updatetime'],
          versioncode: version_content['versioncode'],
          sourcename: version_content['sourcename'],
          app_type: version_content['type'],
          all_download_pid: version_content['all_download_pid'],
          str_download: version_content['strDownload'],
          display_score: version_content['display_score'],
          all_download: version_content['all_download']
        }
      end
    end
    attrs
  end

  # "dev_display": {
  #   "dev_id": "1298979947",
  #   "dev_name": "星罗天下（北京）科技有限公司",
  #   "dev_score": "0",
  #   "dev_level": "0",
  #   "f": "develop_445800_9841968"
  # },
  def build_developer_attrs full_info
    base_info = fetch_base_info full_info
    developer_info = base_info['dev_display']
    {
      origin_id: developer_info['dev_id'],
      name: developer_info['dev_name'],
      score: developer_info['dev_score'],
      level: developer_info['dev_level']
    }
  end

  def build_category_attrs full_info
    base_info = fetch_base_info full_info
    {
      origin_id: base_info['cateid'],
      name: base_info['catename']
    }
  end

  # TODO: test on game with video
  def build_video_attrs full_info
    base_info = fetch_base_info full_info
    {
      :origin_id => base_info['video_id'],
      :videourl => base_info['video_videourl'],
      :playcount => base_info['video_playcount'],
      :image => base_info['video_image'],
      :orientation => base_info['video_orientation'],
      :duration => base_info['video_duration'],
      :source => base_info['video_source'],
      :title => base_info['video_title'],
      :packageid => base_info['video_packageid'],
    }
  end

  #TODO: tests!
  def build_tags_attrs full_info
    base_info = fetch_base_info full_info
    tags_info = base_info['apptags']
    attrs = []
    tags_info.each do |tag|
      attrs << {
        name: tag
      }
    end
    attrs
  end

  #TODO: tests!
  def build_display_tags_attrs full_info
    base_info = fetch_base_info full_info
    tags_info = base_info['tag_display']
    attrs = []
    tags_info.each do |tag_name, tag_data|
      if tag_data['content'].is_a?(Array)
        tag_data['content'].each do |content|
          attrs << {
            name: tag_name,
            content_json: content
          }
        end
      else
        attrs << {
          name: tag_name,
          content: tag_data['content'],
          icon: tag_data['icon'],
          flagicon: tag_data['flagicon']
        }
      end
    end
    attrs
  end

end
