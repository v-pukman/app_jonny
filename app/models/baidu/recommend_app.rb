class Baidu::RecommendApp < ActiveRecord::Base
  include NamespacedModel

  belongs_to :app
  belongs_to :recommend_group
  validates :app_id, :recommend_group_id, :app_type, :packageid, :docid, presence: true
  # groupid can be blank
  validates_uniqueness_of :docid, scope: [:app_id, :packageid, :recommend_group_id]


end
