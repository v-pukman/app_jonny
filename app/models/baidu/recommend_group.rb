class Baidu::RecommendGroup < ActiveRecord::Base
  has_many :recommend_apps
  validates :name, presence: true
end
