class Baidu::DisplayTag < ActiveRecord::Base
  has_and_belongs_to_many :apps

  validates_presence_of :name
end
