class Baidu::Source < ActiveRecord::Base
  include NamespacedModel

  validates :name, presence: true
  validates_uniqueness_of :name

  has_many :apps
end
