class Baidu::Developer < ActiveRecord::Base
  has_many :apps
  has_many :tracks, class_name: 'Baidu::Track::Developer'

  validates :origin_id, presence: true
  validates_uniqueness_of :origin_id

  after_save :save_track

  private

  def save_track
    Baidu::Service::Track::Developer.save_track self
  end
end
