class Baidu::RecommendGroup < ActiveRecord::Base
  include NamespacedModel

  has_many :recommend_apps
  validates :name, presence: true
end
