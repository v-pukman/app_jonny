class Baidu::Version < ActiveRecord::Base
  include NamespacedModel

  belongs_to :app

  validates_uniqueness_of :id_str, scope: :app_id
  validates :app_id, :id_str, :app_type, :packageid, :groupid, :docid, presence: true
  before_validation :set_id_str, on: :create

  private

  def set_id_str
    self.id_str = Baidu::App.build_id_str(self.app_type, self.packageid, self.groupid, self.docid)
  end
end
