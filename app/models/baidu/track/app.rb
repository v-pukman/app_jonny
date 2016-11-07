class Baidu::Track::App < ActiveRecord::Base
  self.table_name = 'baidu_track_apps'
  belongs_to :app, class_name: 'Baidu::App'
  validates_uniqueness_of :app_id, scope: [:day]
end
