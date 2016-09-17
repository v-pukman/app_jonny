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
      attrs = full_info_to_attrs full_info
      # will check for second time
      # because sometimes preview info doesnt have all id
      # also it handles db record dublication error
      app = create_or_update attrs
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

  def full_info_to_attrs full_info
    data = JSON.parse(full_info.to_json)['result']['data']['base_info']
    full_data = JSON.parse(full_info.to_json)['result']['data']['base_info']

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

end
