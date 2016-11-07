class Baidu::Track::Developer < ActiveRecord::Base
  self.table_name = 'baidu_track_developers'
  belongs_to :developer, class_name: 'Baidu::Developer'
  validates_uniqueness_of :day, scope: :developer_id
end
