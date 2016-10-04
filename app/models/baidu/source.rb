class Baidu::Source < ActiveRecord::Base
  validates :name, presence: true
  validates_uniqueness_of :name

  has_many :apps
end
