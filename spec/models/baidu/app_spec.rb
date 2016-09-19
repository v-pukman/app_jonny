require 'rails_helper'

RSpec.describe Baidu::App, type: :model do
  let(:app) { create :baidu_app }
  let(:tag1) { create(:baidu_tag, name: 'super') }
  let(:tag2) {  create(:baidu_tag, name: 'awesome') }
  let(:display_tag1) { create(:baidu_display_tag, name: 'cool') }
  it "has factory" do
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

  it "has many tags" do
    tags = [tag1, tag2]
    app.tags << tags
    expect(app.reload.tags).to match_array tags
  end

  it "updates tags" do
    app.tags = [tag1]
    app.save
    expect(app.reload.tags).to eq [tag1]
    app.tags = [tag2]
    app.save
    expect(app.reload.tags).to eq [tag2]
  end

  it "has display tags" do
    app.display_tags = [display_tag1]
    app.save
    expect(app.reload.display_tags).to eq [display_tag1]
  end
end
