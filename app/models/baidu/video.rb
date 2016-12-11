class Baidu::Video < ActiveRecord::Base
  include NamespacedModel

  belongs_to :app

  validates :app_id, :origin_id, presence: true
end
