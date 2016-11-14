class Baidu::Analytic::Board < Baidu::Analytic::Base
  def self.count_by_type
    board = Baidu::Board.arel_table
    query = board.
            group(board[:action_type]).
            project('action_type, count(*)')

    execute query
  end
end
