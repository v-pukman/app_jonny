class Baidu::Board < ActiveRecord::Base
  include NamespacedModel

  TYPES = [
    GENERAL_BOARD = 'generalboard',
    RANKLIST_BOARD = 'ranklist',
    FEATURE_BOARD = 'featureboard'
  ].freeze

  validates :link, presence: true
  validates_uniqueness_of :link

  before_validation :set_params, on: :create

  scope :generalboard, -> { where(action_type: GENERAL_BOARD) }
  scope :ranklist, -> { where(action_type: RANKLIST_BOARD) }
  scope :featureboard, -> { where(action_type: FEATURE_BOARD) }

  def link_params
    params = {}
    self.link.to_s.gsub('appsrv?', '').split('&').each do |param|
      key = param.split('=')[0]
      value = param.split('=')[1]
      params[key.to_sym] = value
    end
    params
  end

  private

  def set_params
    return if self.link.blank? || (self.origin_id && self.action_type)
    link_params.each do |key, value|
      if (key == :boardid || key == :board || key == :board_id) && self.origin_id.blank?
        self.origin_id = value
      elsif key == :action && self.action_type.blank?
        self.action_type = value
      elsif key == :sorttype && self.sort_type.blank?
        self.sort_type = value
      end
    end
  end

end
