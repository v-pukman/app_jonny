class Baidu::Board < ActiveRecord::Base
  validates :link, presence: true
  validates_uniqueness_of :link

  before_validation :set_params, on: :create

  private

  def set_params
    return if self.link.blank? || (self.origin_id && self.action_type)

    self.link.gsub('appsrv?', '').split('&').each do |link_param|
      key = link_param.split('=')[0]
      value = link_param.split('=')[1]

      if (key == 'boardid' || key == 'board') && self.origin_id.blank?
        self.origin_id = value
      elsif key == 'action' && self.action_type.blank?
        self.action_type = value
      end
    end
  end
end
