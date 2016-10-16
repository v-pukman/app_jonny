namespace :baidu do
  task download_game_ranks: :environment do
    Baidu::Service::Board.new.download_game_rank_boards
    Baidu::Board.ranklist.each do |board|
      p board
      Baidu::Service::Rank.new.download_game_ranks_in_board board
    end
  end

  task download_soft_ranks: :environment do
    Baidu::Service::Rank.new.download_soft_ranks
  end

  task download_boards: :environment do
    Baidu::Service::Board.new.download_boards
  end

  task download_apps_from_boards: :environment do
    boards = Baidu::Board.generalboard
    #boards = [boards.first]
    boards.each do |board|
      Baidu::Log.info 'tasks :baidu', :download_apps_from_boards, "start download", { board_origin_id: board.origin_id }
      Baidu::Service::Board.new.download_apps board
    end
  end

  task clear_logs: :environment do
    Log.clear area: Log::BAIDU_AREA
  end
end
