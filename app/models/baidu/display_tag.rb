class Baidu::DisplayTag < ActiveRecord::Base
  include NamespacedModel

  has_and_belongs_to_many :apps

  validates_presence_of :name
end
