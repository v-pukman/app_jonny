class Baidu::Analytic::Rank < Baidu::Analytic::Base
  # for ranks devided to boards
  def self.count_by_board rank_type, day
    ranks = Baidu::Rank.arel_table
    query = ranks.
            where(ranks[:rank_type].eq(rank_type)).
            where(ranks[:day].eq(day)).
            group('board_id').
            project("info->'board_id'::text AS board_id, count(*)")

    execute query
  end
end
