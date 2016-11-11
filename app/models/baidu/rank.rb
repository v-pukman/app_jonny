class Baidu::Rank < ActiveRecord::Base
  TYPES = [
    SOFT_COMMON_RANK = 'soft_common',
    GAMES_IN_BOARD_RANK = 'games_in_board',
    RISING_RANK = 'rising',
    TOP_RANK = 'top',
    FEATURE_IN_BOARD_RANK = 'feature_in_board'
  ].freeze

  belongs_to :app

  validates :rank_type, :day, :app_id, :rank_number, presence: true

  # for ranks devided to boards
  def self.ranks_count_by_board rank_type, day
    ranks = Baidu::Rank.arel_table
    query = ranks.
            where(ranks[:rank_type].eq(rank_type)).
            where(ranks[:day].eq(day)).
            group('board_id').
            project("info->'board_id'::text AS board_id, count(*)")
    result = ActiveRecord::Base.connection.execute query.to_sql
    result.as_json
  end

  #validates_uniqueness_of :app_id, scope: [:rank_type, :day]
end
