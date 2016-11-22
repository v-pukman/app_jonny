class BaiduMailer < ApplicationMailer
  def log_report
    @time = curr_time.yesterday
    @errors = Log.errors.where area: Log::BAIDU_AREA, created_at: @time.beginning_of_day..@time.end_of_day
    @infos = Log.infos.where area: Log::BAIDU_AREA, created_at: @time.beginning_of_day..@time.end_of_day
    mail subject: "Baidu Log Report"
  end

  #TODO: it's hard to test
  #      move it to Baidu::Report record?
  def data_report
    @time = curr_time.yesterday

    #apps
    @soft_total = Baidu::App.soft.count
    @soft_new = Baidu::App.soft.where(created_at: @time.beginning_of_day..@time.end_of_day).count
    @games_total = Baidu::App.games.count
    @games_new = Baidu::App.games.where(created_at: @time.beginning_of_day..@time.end_of_day).count

    @apps_total = Baidu::App.count

    #tracks
    @app_tracks_total = Baidu::Track::App.count
    @app_tracks_new = Baidu::Track::App.where(day: @time.to_date).count

    #ranks
    @soft_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::SOFT_COMMON_RANK, day: @time.to_date).count
    @game_ranks_new = Baidu::Analytic::Rank.count_by_board Baidu::Rank::GAMES_IN_BOARD_RANK, @time.to_date

    @top_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::TOP_RANK, day: @time.to_date).count
    @rising_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::RISING_RANK, day: @time.to_date).count

    @feature_ranks_new = Baidu::Analytic::Rank.count_by_board Baidu::Rank::FEATURE_IN_BOARD_RANK, @time.to_date

    #boards
    @boards_total = Baidu::Analytic::Board.count_by_type

    mail subject: "Baidu Data Report"
  end

  def curr_time
    Time.now.in_time_zone('Beijing')
    #Date.current.in_time_zone('Beijing') #for date
  end
end
