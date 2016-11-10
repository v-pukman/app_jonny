class BaiduMailer < ApplicationMailer
  def log_report
    @date = Date.yesterday
    @errors = Log.errors.where area: Log::BAIDU_AREA, created_at: @date
    @infos = Log.infos.where area: Log::BAIDU_AREA, created_at: @date
    mail subject: "Baidu Log Report"
  end

  #TODO: tests!
  #TODO: add featured by boards, games by boards statistins
  #      boards count
  def data_report
    @date = Date.yesterday

    @soft_total = Baidu::App.soft.count
    @soft_new = Baidu::App.soft.where(created_at: @date).count
    @games_total = Baidu::App.games.count
    @games_new = Baidu::App.games.where(created_at: @date).count

    @apps_total = Baidu::App.count

    @app_tracks_total = Baidu::Track::App.count
    @app_tracks_new = Baidu::Track::App.where(day: @date).count

    @soft_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::SOFT_COMMON_RANK, day: @date).count
    @game_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::GAMES_IN_BOARD_RANK, day: @date).count

    @top_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::TOP_RANK, day: @date).count
    @rising_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::RISING_RANK, day: @date).count

    @feature_ranks_new = Baidu::Rank.where(rank_type: Baidu::Rank::FEATURE_IN_BOARD_RANK, day: @date).count

    mail subject: "Baidu Data Report"
  end
end
