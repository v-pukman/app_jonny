class Baidu::Track::App < ActiveRecord::Base
  include NamespacedModel

  belongs_to :app, class_name: 'Baidu::App'
  validates_uniqueness_of :app_id, scope: [:day]

  TRACK_ALL_IN_HOURS = 12 #23
  TRACK_ONE_IN_SEC = 3

  def self.not_tracked_ids_sliced day
    allowed_count = (TRACK_ALL_IN_HOURS * 3600) / TRACK_ONE_IN_SEC
    not_tracked_ids = Baidu::Analytic::App.not_tracked_ids day
    not_tracked_ids.each_slice(allowed_count).to_a
  end
end
