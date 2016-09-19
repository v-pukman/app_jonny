#TODO: what is real string size now? 255 or 191?

# get icon url working
#URI.decode('http://cdn00.baidu-img.cn/timg?vsapp\u0026size=b150_150\u0026imgtype=3\u0026quality=100\u0026er\u0026sec=0\u0026di=32fa4b486ef8f5f6d43547762ea02fa9\u0026ref=http%3A%2F%2Fh.hiphotos.bdimg.com\u0026src=http%3A%2F%2Fh.hiphotos.bdimg.com%2Fwisegame%2Fpic%2Fitem%2F3aee3d6d55fbb2fbb41abaf9494a20a44623dc2d.jpg'.gsub('\u0026', '&'))

class Baidu::App < ActiveRecord::Base
  has_many :versions
  belongs_to :developer
  belongs_to :category
  has_one :video
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :display_tags

  validates_uniqueness_of :id_str
  validates :id_str, :app_type, :packageid, :groupid, :docid, presence: true

  before_validation :set_id_str, on: :create

  def self.build_id_str app_type, packageid, groupid, docid
    "#{app_type}_#{packageid}_#{groupid}_#{docid}"
  end

  private

  def set_id_str
    self.id_str = Baidu::App.build_id_str(self.app_type, self.packageid, self.groupid, self.docid)
  end
end

