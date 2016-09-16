class Baidu::Service
  attr_reader :api
  def initialize
    @api = Baidu::ApiClient.new
  end

  def save_app preview_info_source, additional_data={}
    preview_info_source = JSON.parse(preview_info_source.to_json)
    itemdata = preview_info_source['itemdata']
    if itemdata.nil? || itemdata['docid'].nil?
      return nil
    end

    id_str = Baidu::App.build_id_str(itemdata['type'], itemdata['packageid'], itemdata['groupid'], itemdata['docid'])

    p "checking #{id_str}"
    app = Baidu::App.where(id_str: id_str).first
    # create if doesn't exit
    full_info = nil
    if app.nil?
      full_info = api.get(:app, docid: itemdata['docid'])

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

      # rebuild id_str using full data
      # all fields must be filled
      id_str = Baidu::App.build_id_str(attrs['app_type'], attrs['packageid'], attrs['groupid'], attrs['docid'])

      begin
        # check for second time
        # because sometimes preview info doesnt have all id
        p "checking2 #{id_str}"
        app = Baidu::App.where(id_str: id_str).first
        if app.nil?
          app = Baidu::App.new(attrs)
          app.save!
          p "app created #{app.id}"
        else
          app.update_attributes(attrs)
          p "app was updated instead of create: baidu_app_id #{app.id}"
        end
      # handle db dublication error
      rescue ActiveRecord::RecordNotUnique => e
        app = Baidu::App.where(id_str: id_str).first
        app.update_attributes(attrs)
        p "app was updated instead of create on not_uniq error: baidu_app_id #{app.id}"
      end

    else
      p "app already created"
    end

    #save_game_day(app.id, preview_info_source, full_info, search_position, in_board_position)

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


end
