require 'rails_helper'

RSpec.describe Baidu::Service do
  include_context "baidu_api_client_with_default_params"

  let!(:service) { Baidu::Service.new }
  let(:preview_info_source) { json_fixture('baidu/preview_info_source--doudizhu.json') }
  let(:full_info_source) { json_vcr_fixture('baidu/get_app--for-save-app.yml') }

  it { expect(preview_info_source).to_not eq nil }
  it { expect(service.api.is_a?(Baidu::ApiClient)).to eq true }


  describe "#create_or_update" do
    let(:attrs) do
      service.full_info_to_attrs(full_info_source)
    end
    let(:id_str) { Baidu::App.build_id_str(attrs['app_type'], attrs['packageid'], attrs['groupid'], attrs['docid']) }
    it "creates new app" do
      app = service.create_or_update(attrs)
      expect(app.persisted?).to eq true
    end
    it "updates created app" do
      app = create :baidu_app, attrs
      new_brief = 'awesome game!'
      attrs['brief'] = new_brief
      service.create_or_update(attrs)
      expect(app.reload.brief).to eq new_brief
    end
    it "handles ActiveRecord::RecordNotUnique error and updates record" do
      app = create :baidu_app, attrs
      apps = [app]
      allow(apps).to receive(:first).and_return(app)
      allow(Baidu::App).to receive(:where).and_return(apps)
      allow(app).to receive(:nil?).and_raise(ActiveRecord::RecordNotUnique, "error")
      expect(app).to receive(:update_attributes).with(attrs)
      service.create_or_update(attrs)
    end
  end

  describe "#save_from_preview_info" do
    let(:itemdata) { preview_info_source['itemdata'] }
    let(:id_str) { Baidu::App.build_id_str(itemdata['type'], itemdata['packageid'], itemdata['groupid'], itemdata['docid']) }
    it "return nil when no docid" do
      preview_info_source['itemdata'].delete('docid')
      app = service.save_from_preview_info preview_info_source
      expect(app).to eq nil
    end
    it "return nil when itemdata is not Hash" do
      preview_info_source['itemdata'] = []
      app = service.save_from_preview_info preview_info_source
      expect(app).to eq nil
    end
    it "calls create_or_update when app is not created" do
      VCR.use_cassette("baidu/get_app--for-save-app") do
        expect(service).to receive(:create_or_update)
        service.save_from_preview_info preview_info_source
      end
    end
    it "doesnt request data when app exist" do
      app = create :baidu_app, app_type: itemdata['type'], packageid: itemdata['packageid'], groupid: itemdata['groupid'], docid: itemdata['docid']
      expect(app.persisted?).to eq true
      expect(service).to_not receive(:create_or_update)
      service.save_from_preview_info preview_info_source
    end
  end
end
