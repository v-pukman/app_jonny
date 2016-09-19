class Baidu::Category < ActiveRecord::Base
  has_many :apps

  validates :origin_id, :name, presence: true
  validates_uniqueness_of :origin_id
end
