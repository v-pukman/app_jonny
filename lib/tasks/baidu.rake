namespace :baidu do

  desc "download top, rising, featured app ranks"
  task download_crown_ranks: :environment do
    service = Baidu::Service::Rank.new
    board_service = Baidu::Service::Board.new

    service.download_ranks Baidu::Rank::TOP_RANK
    service.download_ranks Baidu::Rank::RISING_RANK

    board_service.download_feature_boards
    Baidu::Board.featureboard.each do |board|
      service.download_ranks Baidu::Rank::FEATURE_IN_BOARD_RANK, board: board
    end
  end

  desc "download game ranks. game ranks are devided to 4 pages. it gets each page"
  task download_game_ranks: :environment do
    Baidu::Service::Board.new.download_game_rank_boards
    Baidu::Board.ranklist.each do |board|
      Baidu::Service::Rank.new.download_ranks Baidu::Rank::GAMES_IN_BOARD_RANK, board: board
    end
  end

  desc "download soft ranks. all soft ranks are located on one page"
  task download_soft_ranks: :environment do
    Baidu::Service::Rank.new.download_ranks Baidu::Rank::SOFT_COMMON_RANK
  end

  desc "download game, soft, game_ranks, featured_apps boards"
  task download_boards: :environment do
    service = Baidu::Service::Board.new
    service.download_boards
    service.download_game_rank_boards
    service.download_feature_boards
  end

  desc "download games and soft apps from catalog"
  task download_apps_from_boards: :environment do
    Baidu::Service::Board.new.download_boards # soft & games

    boards = Baidu::Board.generalboard
    boards.each do |board|
      Baidu::Log.info "tasks :baidu", :download_apps_from_boards, "start download", { board_origin_id: board.origin_id }
      Baidu::Service::Board.new.download_apps board
    end
  end

  task clear_logs: :environment do
    Log.clear area: Log::BAIDU_AREA
  end
end
