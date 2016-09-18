require 'rails_helper'

RSpec.describe Baidu::Service do
  include_context "baidu_api_client_with_default_params"

  let!(:service) { Baidu::Service.new }
  let(:preview_info_source) { json_fixture('static/baidu/preview_info_source--doudizhu.json') }
  let(:full_info_source) { json_vcr_fixture('baidu/get_app--doudizhu.yml') }
  let(:base_info) { service.fetch_base_info(full_info_source) }

  it { expect(preview_info_source).to_not eq nil }
  it { expect(service.api.is_a?(Baidu::ApiClient)).to eq true }

  before do
    VCR.use_cassette("baidu/get_app--doudizhu") do
      service.api.get :app, docid: preview_info_source['itemdata']['docid']
    end
  end


  describe "#create_or_update" do
    let(:attrs) { service.build_app_attrs(full_info_source) }
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
      VCR.use_cassette("baidu/get_app--doudizhu") do
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

  describe "#build_versions_attrs" do
    let(:versions_info) { service.fetch_versions_info(full_info_source) }
    let(:attrs) { service.build_versions_attrs(full_info_source) }

    it "returns array" do
      expect(attrs.is_a?(Array)).to eq true
    end

    it "returns versions data" do
      version_source = versions_info[0]
      version_source_content = version_source['content'][0]

      a = attrs[0]
      expect(a[:name]).to eq version_source['version']
      expect(a[:code]).to eq version_source_content['versioncode']
      expect(a[:docid]).to eq version_source_content['docid']
      expect(a[:packageid]).to eq version_source_content['packageid']
      expect(a[:groupid]).to eq version_source_content['groupid']

      expect(a[:sname]).to eq version_source_content['sname']
      expect(a[:size]).to eq version_source_content['size']
      expect(a[:updatetime]).to eq version_source_content['updatetime']
      expect(a[:versioncode]).to eq version_source_content['versioncode']
      expect(a[:sourcename]).to eq version_source_content['sourcename']
      expect(a[:app_type]).to eq version_source_content['type']
      expect(a[:all_download_pid]).to eq version_source_content['all_download_pid']
      expect(a[:str_download]).to eq version_source_content['strDownload']
      expect(a[:display_score]).to eq version_source_content['display_score']
      expect(a[:all_download]).to eq version_source_content['all_download']
    end

    it "returns all versions" do
      versions_count = versions_info.count
      expect(attrs.count).to be >= versions_count
    end
  end

  describe "#fetch_versions_info" do
    let(:versions_info) { service.fetch_versions_info(full_info_source) }
    let(:version_content_keys) do
      [
        :packageid,
        :groupid,
        :docid,
        :sname,
        :size,
        :updatetime,
        :versioncode,
        :sourcename,
        :type,
        :all_download_pid,
        :strDownload,
        :display_score,
        :all_download,
      ]
    end
    it "returns array" do
      expect(versions_info.is_a?(Array)).to eq true
    end
    it "builds curr version from app info and adds it to the end of list" do
      expect(versions_info.last['version']).to eq base_info['versionname']
      expect(versions_info.last['versioncode']).to eq base_info['versioncode']
      version_content_keys.each do |content_key|
        expect(versions_info.last['content'][0][content_key.to_s]).to eq base_info[content_key.to_s]
      end
    end
  end

  # "dev_display": {
  #   "dev_id": "1298979947",
  #   "dev_name": "星罗天下（北京）科技有限公司",
  #   "dev_score": "0",
  #   "dev_level": "0",
  #   "f": "develop_445800_9841968"
  # },

  describe "#build_developer_attrs" do
    let(:attrs) { service.build_developer_attrs(full_info_source) }
    it "returns developer data" do
      expect(attrs[:origin_id]).to eq base_info['dev_display']['dev_id']
      expect(attrs[:name]).to eq base_info['dev_display']['dev_name']
      expect(attrs[:score]).to eq base_info['dev_display']['dev_score']
      expect(attrs[:level]).to eq base_info['dev_display']['dev_level']
    end
  end

  describe "#build_category_attrs" do
    let(:attrs) { service.build_category_attrs(full_info_source) }
    it "returns category data" do
      expect(attrs[:origin_id]).to eq base_info['cateid']
      expect(attrs[:name]).to eq base_info['catename']
    end
  end


   #  "video_videourl": "",
   #  "video_playcount": "",
   #  "video_image": "",

   #  "video_orientation": "",
   #  "video_duration": "",
   #  "video_source": "",
   #  "video_id": "",
   #  "video_title": "",

   #  "video_packageid": "",
  describe "#build_video_attrs" do
    let(:attrs) { service.build_video_attrs(full_info_source) }
    it "returns video data" do
      expect(attrs[:videourl]).to eq base_info['video_videourl']
      expect(attrs[:playcount]).to eq base_info['video_playcount']
      expect(attrs[:image]).to eq base_info['video_image']
      expect(attrs[:orientation]).to eq base_info['video_orientation']
      expect(attrs[:duration]).to eq base_info['video_duration']
      expect(attrs[:source]).to eq base_info['video_source']
      expect(attrs[:origin_id]).to eq base_info['video_id']
      expect(attrs[:title]).to eq base_info['video_title']
      expect(attrs[:packageid]).to eq base_info['video_packageid']
    end
  end
end
