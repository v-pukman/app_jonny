class Baidu::Video < ActiveRecord::Base
  belongs_to :app

  validates :app_id, :origin_id, presence: true
end
