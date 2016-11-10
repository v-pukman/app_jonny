class Baidu::App < ActiveRecord::Base
  TYPES = [
    SOFT_APP = 'soft',
    GAME_APP = 'game'
  ].freeze

  belongs_to :developer
  belongs_to :category
  belongs_to :source
  has_one :video
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :display_tags
  has_many :recommend_apps
  has_many :versions
  has_many :ranks
  has_many :tracks, class_name: 'Baidu::Track::App'

  validates_uniqueness_of :id_str
  validates :id_str, :app_type, :packageid, :groupid, :docid, presence: true

  before_validation :set_id_str, on: :create
  after_save :save_track

  scope :games, -> { where(app_type: GAME_APP) }
  scope :soft, -> { where(app_type: SOFT_APP) }

  def self.build_id_str app_type, packageid, groupid, docid
    "#{app_type}_#{packageid}_#{groupid}_#{docid}"
  end

  def self.build_id_str_from_attrs attrs
    attrs = attrs.clone
    attrs.symbolize_keys! #deep_symbolize_keys!
    self.build_id_str attrs[:app_type], attrs[:packageid], attrs[:groupid], attrs[:docid]
  end

  # get icon url working
  # URI.decode('http://cdn00.baidu-img.cn/timg?vsapp\u0026size=b150_150\u0026imgtype=3\u0026quality=100\u0026er\u0026sec=0\u0026di=32fa4b486ef8f5f6d43547762ea02fa9\u0026ref=http%3A%2F%2Fh.hiphotos.bdimg.com\u0026src=http%3A%2F%2Fh.hiphotos.bdimg.com%2Fwisegame%2Fpic%2Fitem%2F3aee3d6d55fbb2fbb41abaf9494a20a44623dc2d.jpg'.gsub('\u0026', '&'))

  private

  def set_id_str
    self.id_str = Baidu::App.build_id_str(self.app_type, self.packageid, self.groupid, self.docid)
  end

  def save_track
    Baidu::Service::Track::App.save_track self
  end
end

