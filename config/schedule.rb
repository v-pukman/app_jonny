every 1.day, at: '00:05' do
  rake 'baidu:send_report'
end

every 1.day, at: '00:10' do
  rake 'baidu:download_apps_from_boards'
end

every 1.day, at: '18:05' do
  rake 'baidu:download_soft_ranks'
  rake 'baidu:download_game_ranks'
  rake 'baidu:download_crown_ranks'
end
