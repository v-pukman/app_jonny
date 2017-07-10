class Baidu::Service::Board < Baidu::Service::Base
  def download_apps board
    return if board.origin_id.blank?

    page_number = 0
    next_page = true

    # some stats
    items_count = 0
    saved_count = 0

    while next_page
      puts "page: #{page_number}"
      params = {
        boardid: board.origin_id,
        sorttype: board.sort_type,
        action: board.action_type,
        pn: page_number
      }
      params_from_link = board.link_params.keep_if {|key| !params.keys.include?(key) }
      params_from_link.delete(:board) # remove boardid dublicat

      result = api.get :board, params.merge(params_from_link)
      items = result['result']['data']
      items = items.is_a?(Array) ? items : []
      app_info_count = 0
      items.each do |preview_info|
        items_count += 1
        app = app_service.save_item preview_info
        if app.try(:id)
          saved_count += 1
          app_info_count += 1
        end
      end

      next_page = app_info_count > 0
      page_number += 1
    end

    Log.info Log::BAIDU_AREA, self.class, :download_apps, 'download finished', { board_id: board.id, items_count: items_count, saved_count: saved_count }
  rescue StandardError => e
    Log.error Log::BAIDU_AREA, self.class, :download_apps, e, { board_id: board.try(:id) }
  end

  # get soft and game boards
  def download_boards
    boards_info = api.get :boards, sorttype: 'soft'
    save_boards build_boards_attrs(boards_info)

    boards_info = api.get :boards, sorttype: 'game'
    save_boards build_boards_attrs(boards_info)
  end

  # game ranks devided to few boards
  # get list of boards and save it
  def download_game_rank_boards
    boards_info = api.get :game_ranks, pn: 0
    save_boards build_boards_attrs(boards_info)
  end

  # get featured page and parse all fetureboard boards
  def download_feature_boards
    boards_info = api.get :featured, pn: 0
    save_boards build_boards_attrs(boards_info)
  end

  def build_boards_attrs boards_info
    links = boards_info.to_s.scan /appsrv[\S]+/
    links = links.map {|l| l.split('"')[0] }.compact
    links = links.select {|l| l.include?('&board') && l.include?('&action') }

    links.map do |link|
      { link: link }
    end
  end

  def save_boards boards_attrs
    boards_attrs.each do |board_attrs|
      save_board board_attrs
    end
  end

  #TODO: test!
  def save_board board_attrs
    board = Baidu::Board.where(link: board_attrs[:link]).first
    if board.nil?
      board = Baidu::Board.new(board_attrs)
      board.save!
    end
    board
  rescue ActiveRecord::RecordNotUnique
    Baidu::Board.where(link: board_attrs[:link]).first
  rescue StandardError => e
    Log.error Log::BAIDU_AREA, self.class, :save_board, e, board_attrs
    nil
  end

  def app_service
    @app_service ||= Baidu::Service::App.new
  end
end
