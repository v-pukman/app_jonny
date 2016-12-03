namespace :baidu do

  desc "tracks every not tracked app. must run every day."
  task update_apps: :environment do
    TaskMailer.status_report(TaskMailer::STARTED, :update_apps).deliver_now
    Baidu::Service::App.new.update_apps
    TaskMailer.status_report(TaskMailer::COMPLETED, :update_apps).deliver_now
  end

  desc "send daily report to admin email"
  task send_report: :environment do
    BaiduMailer.log_report.deliver_now
    BaiduMailer.data_report.deliver_now
  end

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

    TaskMailer.status_report(TaskMailer::COMPLETED, :download_crown_ranks).deliver_now
  end

  desc "download game ranks. game ranks are devided to 4 pages. it gets each page"
  task download_game_ranks: :environment do
    Baidu::Service::Board.new.download_game_rank_boards
    Baidu::Board.ranklist.each do |board|
      Baidu::Service::Rank.new.download_ranks Baidu::Rank::GAMES_IN_BOARD_RANK, board: board
    end
    TaskMailer.status_report(TaskMailer::COMPLETED, :download_game_ranks).deliver_now
  end

  desc "download soft ranks. all soft ranks are located on one page"
  task download_soft_ranks: :environment do
    Baidu::Service::Rank.new.download_ranks Baidu::Rank::SOFT_COMMON_RANK
    TaskMailer.status_report(TaskMailer::COMPLETED, :download_soft_ranks).deliver_now
  end

  desc "download game, soft, game_ranks, featured_apps boards"
  task download_boards: :environment do
    service = Baidu::Service::Board.new
    service.download_boards
    service.download_game_rank_boards
    service.download_feature_boards
    TaskMailer.status_report(TaskMailer::COMPLETED, :download_boards).deliver_now
  end

  desc "download games and soft apps from catalog"
  task download_apps_from_boards: :environment do
    TaskMailer.status_report(TaskMailer::STARTED, :download_apps_from_boards).deliver_now
    Baidu::Service::Board.new.download_boards # soft & games

    boards = Baidu::Board.generalboard
    boards.each do |board|
      #Baidu::Log.info "tasks :baidu", :download_apps_from_boards, "start download", { board_origin_id: board.origin_id }
      Baidu::Service::Board.new.download_apps board
    end
    TaskMailer.status_report(TaskMailer::COMPLETED, :download_apps_from_boards).deliver_now
  end

  task clear_logs: :environment do
    Log.clear area: Log::BAIDU_AREA
  end
end
