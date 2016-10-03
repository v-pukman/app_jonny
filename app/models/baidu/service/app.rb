class Baidu::Service::App < Baidu::Service::Base
  def download_apps_from_board board
    page_number = 0
    next_page = true

    while next_page
      params = {
        boardid: board.origin_id,
        sorttype: board.sort_type,
        action: board.action_type,
        pn: page_number
      }
      result = api.get :board, params
      items = result['result']['data']
      items = items.is_a?(Array) ? items : []
      items.each do |preview_info|
        handle_preview_info preview_info
      end

      next_page = items.any?
      page_number += 1
    end
  end

  def download_app docid
    full_info = api.get :app, docid: docid

    app = save_app build_app_attrs(full_info)

    save_versions app, build_versions_attrs(full_info)
    save_video app, build_video_attrs(full_info)
    save_recommend_apps app, build_recommend_apps_attrs(full_info)

    developer = save_developer build_developer_attrs(full_info)
    app.developer = developer if developer && developer.id

    category = save_category build_category_attrs(full_info)
    app.category = category if category && category.id

    tags = save_tags build_tags_attrs(full_info)
    app.tags = tags if tags.any?

    display_tags = save_display_tags build_display_tags_attrs(full_info)
    app.display_tags = display_tags if display_tags.any?

    app.save!
    app
  rescue StandardError => e
    Baidu::Log.error self.class, :download_app, e, { docid: docid  }
    nil
  end

  ######################
  ### helper methods ###
  ######################

  # preview_info example - fixtures/static/baidu/preview_info_source
  def handle_preview_info preview_info, additional_data={}
    preview_info = JSON.parse(preview_info.to_json)
    full_info = nil
    itemdata = preview_info['itemdata']
    if itemdata.nil? || !itemdata.is_a?(Hash) || itemdata['docid'].nil?
      return nil
    end

    id_str = Baidu::App.build_id_str(itemdata['type'], itemdata['packageid'], itemdata['groupid'], itemdata['docid'])
    app = Baidu::App.where(id_str: id_str).first
    if app.nil?
      app = download_app itemdata['docid']
    end

    #save_game_day(app.id, preview_info, full_info, search_position, in_board_position)
    app
  rescue StandardError => e
    Baidu::Log.error self.class, :handle_preview_info, e, { preview_info: preview_info }
    nil
  end

  def save_app attrs
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

  def save_versions app, versions_attrs
    versions_attrs.each do |attrs|
      id_str = Baidu::Version.build_id_str_from_attrs(attrs)
      version = app.versions.where(id_str: id_str).first
      begin
        if version.nil?
          version = app.versions.build(attrs)
          version.save!
        else
          version.update_attributes(attrs)
        end
      rescue ActiveRecord::RecordNotUnique
        version = app.versions.where(id_str: id_str)
        version.update_attributes(attrs)
      rescue StandardError => e
        Baidu::Log.error self.class, :save_versions, e
      end
    end
  rescue StandardError => e
    Baidu::Log.error self.class, :save_versions, e
  end

  def save_developer developer_attrs
    developer = Baidu::Developer.where(origin_id: developer_attrs[:origin_id]).first
    if developer.nil?
      developer = Baidu::Developer.create!(developer_attrs)
    else
      developer.update_attributes(developer_attrs)
    end
    developer
  rescue ActiveRecord::RecordNotUnique
    developer = Baidu::Developer.where(origin_id: developer_attrs[:origin_id]).first
    developer
  rescue StandardError => e
    Baidu::Log.error self.class, :save_developer, e
    nil
  end

  def save_video app, video_attrs
    if video_attrs[:origin_id]
      video = app.video
      if video.nil?
        video = app.build_video(video_attrs)
        video.save!
      else
        video.update_attributes(video_attrs)
      end
      video
    else
      nil
    end
  rescue ActiveRecord::RecordNotUnique
    app.video.reload
  rescue StandardError => e
    Baidu::Log.error self.class, :save_video, e
    nil
  end

  def save_category category_attrs
    category = Baidu::Category.where(origin_id: category_attrs[:origin_id]).first
    if category.nil?
      category = Baidu::Category.create!(category_attrs)
    else
      category.update_attributes(category_attrs)
    end
    category
  rescue ActiveRecord::RecordNotUnique
    category = Baidu::Category.where(origin_id: category_attrs[:origin_id]).first
    category
  rescue StandardError => e
    Baidu::Log.error self.class, :save_category, e
    nil
  end

  def save_tags tags_attrs
    tags_attrs.map {|tag| Baidu::Tag.where(name: tag[:name]).first_or_create }
  rescue StandardError => e
    Baidu::Log.error self.class, :save_tags, e
    []
  end

  def save_display_tags display_tags_attrs
    display_tags_attrs.map do |tag_attrs|
      begin
        tag = Baidu::DisplayTag.where(name: tag_attrs[:name], content: tag_attrs[:content], content_json: tag_attrs[:content_json].to_s).first
        tag = Baidu::DisplayTag.create!(tag_attrs) if tag.nil?
        tag
      rescue ActiveRecord::RecordNotUnique
        tag = Baidu::DisplayTag.where(name: tag_attrs[:name], content: tag_attrs[:content], content_json: tag_attrs[:content_json].to_s).first
        tag
      rescue StandardError => e
        Baidu::Log.error self.class, :save_display_tags, e
        nil
      end
    end.compact
  rescue StandardError => e
    Baidu::Log.error self.class, :save_display_tags, e
    []
  end

  def save_recommend_apps app, recommend_apps_attrs
    recommend_apps_attrs.each do |attrs|
      begin
        group = nil
        begin
          group = Baidu::RecommendGroup.where(name: attrs[:group_name]).first_or_create
        rescue ActiveRecord::RecordNotUnique
          group = Baidu::RecommendGroup.where(name: attrs[:group_name]).first
        end

        recommend_app = app.recommend_apps.where(recommend_group_id: group.id, packageid: attrs[:packageid], docid: attrs[:docid]).first
        if recommend_app.nil?
          recommend_app = app.recommend_apps.build({
            sname: attrs[:sname],
            app_type: attrs[:app_type],
            packageid: attrs[:packageid],
            groupid: attrs[:groupid],
            docid: attrs[:docid],
            recommend_group_id: group.id,
            recommend: attrs[:recommend]
          })
          recommend_app.save!
        end
      rescue ActiveRecord::RecordNotUnique
        # don't need to update
      rescue StandardError => e
        Baidu::Log.error self.class, :save_recommend_apps, e
      end #begin end
    end #each end
  rescue StandardError => e
    Baidu::Log.error self.class, :save_recommend_apps, e
  end

  def fetch_data_info full_info
    JSON.parse(full_info.to_json)['result']['data']
  end

  def fetch_base_info full_info
    fetch_data_info(full_info)['base_info']
  end

  def build_app_attrs full_info
    data = fetch_base_info full_info
    full_data = fetch_base_info full_info #pointer fix

    attrs = data.keep_if {|a| Baidu::App.column_names.include?(a.to_s)}
    attrs['today_str_download'] = full_data['today_strDownload']
    attrs['now_download'] = full_data['nowDownload']
    attrs['app_type'] = full_data['type']

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
   # "video": {
   #        "videourl": "http://hc34.aipai.com/user/668/33768668/6240107/card/43449648/card.mp4",
   #        "playcount": 10,
   #        "iconurl": "http://apps2.bdimg.com/store/static/kvt/98ddcd02afed7c217ba8f6609ba95c7b.jpg",
   #        "orientation": 80,
   #        "duration": "3分26秒",
   #        "from": "爱拍原创",
   #        "id": 183,
   #        "title": "阴阳师：妖魔鬼怪的爱恨情仇",
   #        "packageid": "1778347"
   #      },
  def build_video_attrs full_info
    base_info = fetch_base_info full_info
    video_info = base_info['video']
    # video_image only in base_info
    if video_info
      {
        :origin_id => video_info['id'],
        :videourl => video_info['videourl'],
        :playcount => video_info['playcount'],
        :image => base_info['video_image'],
        :orientation => video_info['orientation'],
        :duration => video_info['duration'],
        :source => video_info['from'],
        :title => video_info['title'],
        :packageid => video_info['packageid'],
      }
    else
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
  end

  def build_tags_attrs full_info
    base_info = fetch_base_info full_info
    base_info['apptags'].map{|tag| {name: tag} }
  end

  def build_display_tags_attrs full_info
    base_info = fetch_base_info full_info
    tags_info = base_info['tag_display']
    attrs = []
    tags_info.each do |tag_name, tag_data|
      if tag_data['content'].is_a?(Array)
        tag_data['content'].each do |content|
          attrs << {
            name: tag_name,
            content_json: content.to_json,
            content: "",
            icon: tag_data['icon'],
            flagicon: tag_data['flagicon']
          }
        end
      else
        attrs << {
          name: tag_name,
          content_json: "{}",
          content: tag_data['content'],
          icon: tag_data['icon'],
          flagicon: tag_data['flagicon']
        }
      end
    end
    attrs
  end

  # def build_recommend_groups_attrs full_info
  #   recommend_info = fetch_data_info(full_info)['recommend_info']
  #   groups = recommend_info.map{|d| { name: d['recommend_title']} }
  #   groups
  # end

  def build_recommend_apps_attrs full_info
    recommend_info = fetch_data_info(full_info)['recommend_info']
    apps = []
    recommend_info.map do |group|
      group_name = group['recommend_title']
      group['recommend_appinfo'].each do |app|
        apps << {
          group_name: group_name,
          sname: app['sname'],
          app_type: app['type'],
          packageid: app['packageid'],
          groupid: app['groupid'],
          docid: app['docid'],
          recommend: app['recommend']
        }
      end
    end
    apps
  end

end
