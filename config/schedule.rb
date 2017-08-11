every 1.day, at: '17:05' do
  rake 'baidu:send_report'
end

every 1.day, at: '18:00' do
  rake 'baidu:download_apps_from_boards' #~1hour
  #rake 'baidu:download_soft_ranks' #~15min
  #rake 'baidu:download_game_ranks'
  #rake 'baidu:download_crown_ranks'
  #rake 'baidu:update_apps' #1. select not updated 2. split to few proccess
end

every 1.day, at: '19:00' do
  rake 'baidu:download_soft_ranks' #~15min
  rake 'baidu:download_game_ranks'
  rake 'baidu:download_crown_ranks'
end

#every 1.day, at: '01:00' do
#  rake 'baidu:update_apps' #1. select not updated 2. split to few proccess
#end
