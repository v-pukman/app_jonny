namespace :baidu do


  task download_crown_ranks: :environment do
    service = Baidu::Service::Rank.new
    service.download_ranks Baidu::Rank::TOP_RANK
    service.download_ranks Baidu::Rank::RISING_RANK
    Baidu::Board.featureboard.each do |board|
      service.download_ranks Baidu::Rank::FEATURE_IN_BOARD_RANK, board: board
    end
  end

  # game ranks devided to 4 pages
  task download_game_ranks: :environment do
    Baidu::Board.ranklist.each do |board|
      Baidu::Service::Rank.new.download_ranks Baidu::Rank::GAMES_IN_BOARD_RANK, board: board
    end
  end

  # all soft ranks on one page
  task download_soft_ranks: :environment do
    Baidu::Service::Rank.new.download_soft_ranks
  end

  # run first!
  task download_boards: :environment do
    service = Baidu::Service::Board.new
    service.download_boards
    service.download_game_rank_boards
    service.download_feature_boards
  end

  # soft + games
  task download_apps_from_boards: :environment do
    boards = Baidu::Board.generalboard
    #boards = [boards.first]
    boards.each do |board|
      Baidu::Log.info "tasks :baidu", :download_apps_from_boards, "start download", { board_origin_id: board.origin_id }
      Baidu::Service::Board.new.download_apps board
    end
  end

  task clear_logs: :environment do
    Log.clear area: Log::BAIDU_AREA
  end
end
