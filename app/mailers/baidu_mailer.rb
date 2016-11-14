class BaiduMailer < ApplicationMailer
  def log_report
    @date = Date.yesterday
    @errors = Log.errors.where area: Log::BAIDU_AREA, created_at: @date.beginning_of_day..@date.end_of_day
    @infos = Log.infos.where area: Log::BAIDU_AREA, created_at: @date.beginning_of_day..@date.end_of_day
    mail subject: "Baidu Log Report"
  end

  #TODO: it's hard to test
  #      move it to Baidu::Report record?
  def data_report
    @date = Date.yesterday

    #apps
    @soft_total = Baidu::App.soft.count
    @soft_new = Baidu::App.soft.where(created_at: @date.beginning_of_day..@date.end_of_day).count
    @games_total = Baidu::App.games.count
    @games_new = Baidu::App.games.where(created_at: @date.beginning_of_day..@date.end_of_day).count

    @apps_total = Baidu::App.count

    #tracks
    @app_tracks_total = Baidu::Track::App.count
    @app_tracks_new = Baidu::Track::App.where(day: @date).count

    #ranks
    @soft_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::SOFT_COMMON_RANK, day: @date).count
    @game_ranks_new = Baidu::Analytic::Rank.count_by_board Baidu::Rank::GAMES_IN_BOARD_RANK, @date

    @top_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::TOP_RANK, day: @date).count
    @rising_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::RISING_RANK, day: @date).count

    @feature_ranks_new = Baidu::Analytic::Rank.count_by_board Baidu::Rank::FEATURE_IN_BOARD_RANK, @date

    #boards
    @boards_total = Baidu::Analytic::Board.count_by_type

    mail subject: "Baidu Data Report"
  end
end
