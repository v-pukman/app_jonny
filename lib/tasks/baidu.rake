namespace :baidu do
  task :download_boards => :environment do
    Baidu::Service::Board.new.download_boards
  end
end
