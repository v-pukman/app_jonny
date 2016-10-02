class Baidu::Tag < ActiveRecord::Base
  has_and_belongs_to_many :apps

  validates_uniqueness_of :name
  validates_presence_of :name
end