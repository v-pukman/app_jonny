class Baidu::Service::Rank < Baidu::Service::Base

  def download_ranks rank_type, options={}
    page_number = 0
    next_page = true

    items_count = 0
    saved_count = 0

    while next_page

      info = {}
      case rank_type
      when Baidu::Rank::SOFT_COMMON_RANK
        response = api.get :soft_ranks, pn: page_number
      when Baidu::Rank::GAMES_IN_BOARD_RANK
        board = options[:board]
        raise "Board is invalid" if board.nil? || board.origin_id.blank? || board.action_type != Baidu::Board::RANKLIST_BOARD
        info = { board_id: board.id }
        response = api.get :game_ranks, board_id: board.origin_id, pn: page_number
      when Baidu::Rank::TOP_RANK
        response = api.get :ranks, action: 'ranktoplist', pn: page_number
      when Baidu::Rank::RISING_RANK
        response = api.get :ranks, action: 'risingrank', pn: page_number
      when Baidu::Rank::FEATURE_IN_BOARD_RANK
        board = options[:board]
        raise "Board is invalid" if board.nil? || board.origin_id.blank? || board.action_type != Baidu::Board::FEATURE_BOARD
        info = { board_id: board.id }
        response = api.get :featured_board, board: board.origin_id, pn: page_number
      end

      items = fetch_items response
      apps_info_count = 0

      items.each do |preview_info|
        items_count += 1
        app = app_service.save_item preview_info
        if app.try(:id)
          apps_info_count += 1
          rank = save_rank app, build_rank_attrs(preview_info, rank_type, info)
          saved_count += 1 if rank.try(:id)
        end
      end

      next_page = apps_info_count > 0
      page_number += 1
    end #while end

    Baidu::Log.info self.class, :download_ranks, 'download finished', { rank_type: rank_type, options: options, items_count: items_count, saved_count: saved_count }
  rescue StandardError => e
    Baidu::Log.error self.class, :download_ranks, e, { rank_type: rank_type, options: options }
  end

  def save_rank app, rank_attrs
    return nil if app.nil? || app.id.nil? || rank_attrs.blank?

    rank_query = app.ranks.where(day: rank_attrs[:day], rank_type: rank_attrs[:rank_type])
    if rank_attrs[:info][:board_id]
      rank_query = rank_query.where("info->'board_id' = ?", rank_attrs[:info][:board_id].to_s)
    end

    rank = rank_query.first
    if rank.nil?
      rank = app.ranks.build(rank_attrs)
      rank.save!
    else
      # dont update rank_attrs for now
    end
    rank
  rescue ActiveRecord::RecordNotUnique
    app.ranks.where(day: rank_attrs[:day], rank_type: rank_attrs[:rank_type]).first
  rescue StandardError => e
    Baidu::Log.error self.class, :save_rank, e, rank_attrs
    nil
  end

  ### Helpers ###

  def fetch_items full_info
    full_info = JSON.parse(full_info.to_json)
    original_items = full_info['result'].is_a?(Hash) ? full_info['result']['data'] : []

    extracted = []
    original_items.each do |preview_info|
      if preview_info['itemdata'].is_a?(Hash)
        if preview_info['itemdata']['app_data'].is_a?(Array)
          preview_info['itemdata']['app_data'].each {|d| extracted << { 'itemdata' => d } }
        elsif preview_info['itemdata']['app_data'].is_a?(Hash)
          extracted << { 'itemdata' => preview_info['itemdata']['app_data'] }
        elsif preview_info['itemdata']['app'].is_a?(Hash)
          extracted << { 'itemdata' => preview_info['itemdata']['app'] }
        end
      end
    end
    extracted + original_items
  end

  def build_rank_attrs preview_info, rank_type, additional_info={}
    itemdata = app_service.fetch_itemdata_info preview_info
    return {} unless app_service.has_app_info? itemdata

    info = {}
    info[:heat_value] = itemdata['heat_value'].to_f if itemdata['heat_value']
    info[:rise_percent] = itemdata['rise_percent'].to_s.gsub("%", "").to_f if itemdata['rise_percent']
    info.merge! additional_info
    {
      rank_type: rank_type,
      day: Date.today,
      rank_number: itemdata['rankingnum'],
      info: info
    }
  end

  def app_service
    @app_service ||= Baidu::Service::App.new
  end
end
