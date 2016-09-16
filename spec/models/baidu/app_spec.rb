require 'rails_helper'

RSpec.describe Baidu::App, type: :model do
  it "has factory" do
    app = create :baidu_app
    expect(app.persisted?).to eq true
  end

  describe ".build_id_str" do
    let(:app_type) { "game" }
    let(:packageid) { 123 }
    let(:groupid) { 567 }
    let(:docid) { 985 }
    it "returns id with app type and its ids" do
      id_str = Baidu::App.build_id_str(app_type, packageid, groupid, docid)
      expect(id_str).to eq "#{app_type}_#{packageid}_#{groupid}_#{docid}"
    end
  end
end
