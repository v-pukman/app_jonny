class Baidu::Rank < ActiveRecord::Base
  include NamespacedModel

  TYPES = [
    SOFT_COMMON_RANK = 'soft_common',
    GAMES_IN_BOARD_RANK = 'games_in_board',
    RISING_RANK = 'rising',
    TOP_RANK = 'top',
    FEATURE_IN_BOARD_RANK = 'feature_in_board'
  ].freeze

  belongs_to :app

  validates :rank_type, :day, :app_id, :rank_number, presence: true

  #validates_uniqueness_of :app_id, scope: [:rank_type, :day]
end
