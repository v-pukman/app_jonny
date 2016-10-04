namespace :baidu do
  task :download_boards => :environment do
    Baidu::Service::Board.new.download_boards
  end

  task :download_apps_from_boards => :environment do
    boards = Baidu::Board.all
    boards = [boards.first]
    boards.each do |board|
      Baidu::Log.info 'tasks :baidu', :download_apps_from_boards, "start download", { board_origin_id: board.origin_id }
      Baidu::Service::App.new.download_apps_from_board board
    end
  end
end
