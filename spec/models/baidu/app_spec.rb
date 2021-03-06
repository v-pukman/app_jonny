require 'rails_helper'

RSpec.describe Baidu::App, type: :model do
  let(:app) { create :baidu_app }
  let(:tag1) { create(:baidu_tag, name: 'super') }
  let(:tag2) {  create(:baidu_tag, name: 'awesome') }
  let(:display_tag1) { create(:baidu_display_tag, name: 'cool') }
  it "has factory" do
    expect(app.persisted?).to eq true
  end

  context "after save" do
    it "saves track" do
      app.today_download_pid = 5000
      expect(Baidu::Service::Track::App).to receive(:save_track).with(app)
      app.save
    end
  end

  it "has games scope" do
    game = create :baidu_app, app_type: Baidu::App::GAME_APP
    other = create :baidu_app, app_type: Baidu::App::SOFT_APP
    expect(Baidu::App.games).to eq [game]
  end

  it "has soft scope" do
    soft = create :baidu_app, app_type: Baidu::App::SOFT_APP
    other = create :baidu_app, app_type: Baidu::App::GAME_APP
    expect(Baidu::App.soft).to eq [soft]
  end

  it "has available scope" do
    app1 = create :baidu_app
    app2 = create :baidu_app, not_available_count: Baidu::App::NOT_AVAILABLE_MAX
    app3 = create :baidu_app, not_available_count: Baidu::App::NOT_AVAILABLE_MAX + 1
    result = Baidu::App.available.pluck :id
    expect(result).to match_array [app1.id, app2.id]
    expect(result).to_not include [app3.id]
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

  describe ".build_id_str_from_attrs" do
    let(:app_type) { "soft" }
    let(:packageid) { 123 }
    let(:groupid) { 567 }
    let(:docid) { 985 }
    let(:attrs) do
      { app_type: app_type, packageid: packageid, groupid: groupid, docid: docid }
    end
    it "returns id with app type and its ids" do
      id_str = Baidu::App.build_id_str_from_attrs attrs
      expect(id_str).to eq "#{app_type}_#{packageid}_#{groupid}_#{docid}"
    end

    context "when attrs with string keys" do
      let(:attrs_with_string_keys) do
        { 'app_type' => app_type, 'packageid' => packageid, 'groupid' => groupid, 'docid' => docid }
      end
      it "returns id with app type and its ids" do
        id_str = Baidu::App.build_id_str_from_attrs attrs_with_string_keys
        expect(id_str).to eq "#{app_type}_#{packageid}_#{groupid}_#{docid}"
      end
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
