class Baidu::Version < ActiveRecord::Base
  belongs_to :app

  validates_uniqueness_of :id_str, scope: :app_id
  validates :app_id, :id_str, :app_type, :packageid, :groupid, :docid, :name, presence: true
  before_validation :set_id_str, on: :create

  def self.build_id_str app_type, packageid, groupid, docid
    "#{app_type}_#{packageid}_#{groupid}_#{docid}"
  end

  def self.build_id_str_from_attrs attrs
    #raise ArgumentError, "id_str build failed" if attrs[:app_type].nil? || attrs[:packageid].nil? || attrs[:groupid].nil? || attrs[:docid].nil?
    "#{attrs[:app_type]}_#{attrs[:packageid]}_#{attrs[:groupid]}_#{attrs[:docid]}"
  end

  private

  def set_id_str
    self.id_str = Baidu::Version.build_id_str(self.app_type, self.packageid, self.groupid, self.docid)
  end
end
