class Baidu::Service::Rank < Baidu::Service::Base
  # top ranks
  # rising ranks
  # feature ranks

  # move ranks to one method
  # rank_type as parameter

  # get game ranks inside rank board
  # also see download_game_rank_boards at Baidu::Service::Board
  # def download_game_ranks_in_board ranklist_board
  #   return if ranklist_board.origin_id.blank? || ranklist_board.action_type != 'ranklist'

  #   #return if ranklist_board.id != 143

  #   page_number = 0
  #   next_page = true

  #   items_count = 0
  #   saved_count = 0

  #   while next_page
  #     response = api.get :game_ranks, board_id: ranklist_board.origin_id, pn: page_number

  #     items = response['result']['data']
  #     unless items.is_a?(Array)
  #      Baidu::Log.info self.class, :download_game_ranks_in_board, 'data field is not array', { response: response }
  #      break
  #     end

  #     File.write "downloads/baidu/game_ranks_in_board/rank_#{ranklist_board.id}_#{page_number}.json", response.to_json

  #     apps_info_count = 0
  #     items.each do |preview_info|

  #       items_count += 1
  #       app = app_service.save_item preview_info
  #       puts app.sname

  #       if app.try(:id)
  #         apps_info_count += 1
  #         rank = save_rank app, build_rank_attrs(preview_info, Baidu::Rank::GAMES_IN_BOARD_RANK, { board_id: ranklist_board.id })
  #         saved_count += 1 if rank.try(:id)
  #       end
  #     end

  #     next_page = apps_info_count > 0
  #     page_number += 1
  #   end

  #   Baidu::Log.info self.class, :download_game_ranks_in_board, 'download finished', { items_count: items_count, saved_count: saved_count }
  # rescue StandardError => e
  #   Baidu::Log.error self.class, :download_game_ranks_in_board, e
  # end

  # def download_soft_ranks
  #   page_number = 0
  #   next_page = true

  #   items_count = 0
  #   saved_count = 0

  #   while next_page
  #     result = api.get :soft_ranks, pn: page_number

  #     items = result['result']['data']
  #     apps_info_count = 0

  #     items.each do |preview_info|
  #       items_count += 1
  #       app = app_service.save_item preview_info
  #       if app.try(:id)
  #         apps_info_count += 1
  #         rank = save_rank app, build_rank_attrs(preview_info, Baidu::Rank::SOFT_COMMON_RANK)
  #         saved_count += 1 if rank.try(:id)
  #       end
  #     end

  #     next_page = apps_info_count > 0
  #     page_number += 1
  #   end

  #   Baidu::Log.info self.class, :download_soft_ranks, 'download finished', { items_count: items_count, saved_count: saved_count }
  # rescue StandardError => e
  #   Baidu::Log.error self.class, :download_soft_ranks, e
  # end

  def download_ranks rank_type, options={}
    page_number = 0
    next_page = true

    items_count = 0
    saved_count = 0

    while next_page
      info = {}
      case rank_type
      when Baidu::Rank::SOFT_COMMON_RANK
        result = api.get :soft_ranks, pn: page_number
      when Baidu::Rank::GAMES_IN_BOARD_RANK
        board = options[:board]
        raise "Board is invalid" if board.nil? || board.origin_id.blank? || board.action_type != Baidu::Board::RANKLIST_BOARD
        info = { board_id: board.id }
        result = api.get :game_ranks, board_id: board.origin_id, pn: page_number
      end

      items = result['result']['data']
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
    end

    Baidu::Log.info self.class, :download_ranks, 'download finished', { rank_type: rank_type, options: options, items_count: items_count, saved_count: saved_count }
  rescue StandardError => e
    Baidu::Log.error self.class, :download_ranks, e, { rank_type: rank_type, options: options }
  end

  def save_rank app, rank_attrs
    return nil if app.nil? || app.id.nil?

    #TODO: test!
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

  def build_rank_attrs preview_info, rank_type, info={}
    itemdata = app_service.fetch_itemdata_info preview_info
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

  # def fetch_rank_board_links game_ranks_info
  #   board_service.build_boards_attrs game_ranks_info
  #   # list = []
  #   # return list unless game_ranks_info.is_a? Array

  #   # game_ranks_info.each do |item|
  #   #   if item.is_a?(Hash) && itemdata = item['itemdata']
  #   #     if itemdata.is_a?(Hash) && itemdata['groupheader'] && itemdata['groupheader']['itemdata']
  #   #       tablist = itemdata['groupheader']['itemdata']['tablist'] || []
  #   #       tablist.each {|t| list << t['url'] }
  #   #     end
  #   #   end
  #   # end

  #   # list.compact.uniq
  # end
end
