class Baidu::Track::Developer < ActiveRecord::Base
  include NamespacedModel

  belongs_to :developer, class_name: 'Baidu::Developer'
  validates_uniqueness_of :day, scope: :developer_id
end
