require 'rails_helper'

RSpec.describe Baidu::Service::App do
  include_context "baidu_api_client_with_default_params"

  let!(:service) { Baidu::Service::App.new }
  let(:app) { create :baidu_app }
  let(:preview_info_source) { json_fixture('static/baidu/preview_info_source--doudizhu.json') }
  let(:docid) { preview_info_source['itemdata']['docid'] }
  let(:full_info_source) { json_vcr_fixture('baidu/get_app--doudizhu.yml') }
  # all data
  let(:data_info) { service.fetch_data_info(full_info_source) }
  # base info = app info
  let(:base_info) { service.fetch_base_info(full_info_source) }

  it { expect(preview_info_source).to_not eq nil }
  it { expect(service.api.is_a?(Baidu::ApiClient)).to eq true }

  before do
    VCR.use_cassette("baidu/get_app--doudizhu") do
      service.api.get :app, docid: preview_info_source['itemdata']['docid']
    end
  end

  describe "#fetch_data_info" do
    let(:data_info) { service.fetch_data_info full_info_source }
    it "retruns hash with data" do
      expect(data_info.is_a?(Hash)).to eq true
      expect(data_info.keys.include?('base_info')).to eq true
    end
  end

  describe "#fetch_base_info" do
    let(:base_info) { service.fetch_base_info full_info_source }
    it "returns app info" do
      expect(base_info['docid']).to_not eq nil
      expect(base_info['sname']).to_not eq nil
    end
  end

  describe "#download_apps_from_board" do
    let(:board_info) {  json_vcr_fixture('baidu/get_board.yml') }
    let(:origin_id) { 'board_100_0105' }
    let(:sort_type) { 'game' }
    let(:action_type) { 'generalboard' }
    let(:link) { "appsrv?native_api=1&sorttype=#{sort_type}&boardid=#{origin_id}&action=#{action_type}" }
    let(:board) { create :baidu_board, link: link }
    it "calls save_item" do
      allow(service.api).to receive(:get).with(:board, {
        boardid: board.origin_id,
        sorttype: board.sort_type,
        action: board.action_type,
        pn: 0,
        native_api: "1"
      }).and_return(board_info)
      allow(service.api).to receive(:get).with(:board, {
        boardid: board.origin_id,
        sorttype: board.sort_type,
        action: board.action_type,
        pn: 1,
        native_api: "1"
      }).and_return({'result' => { 'data' => [] }})
      expect(service).to receive(:save_item).at_least(:once)
      service.download_apps_from_board board
    end
  end


  describe "#save_app" do
    let(:attrs) { service.build_app_attrs(full_info_source) }
    let(:id_str) { Baidu::App.build_id_str(attrs['app_type'], attrs['packageid'], attrs['groupid'], attrs['docid']) }
    it "creates new app" do
      app = service.save_app(attrs)
      expect(app.persisted?).to eq true
    end
    it "returns already saved app" do
      app = create :baidu_app, app_type: attrs['app_type'], packageid: attrs['packageid'], groupid: attrs['groupid'], docid: attrs['docid']
      expect(app.persisted?).to eq true
      app2 = service.save_app attrs
      expect(app2).to eq app
    end
    it "updates created app" do
      app = create :baidu_app, attrs
      new_brief = 'awesome game!'
      attrs['brief'] = new_brief
      service.save_app(attrs)
      expect(app.reload.brief).to eq new_brief
    end
    it "handles ActiveRecord::RecordNotUnique error and updates record" do
      app = create :baidu_app, attrs
      apps = [app]
      allow(apps).to receive(:first).and_return(app)
      allow(Baidu::App).to receive(:where).and_return(apps)
      allow(app).to receive(:nil?).and_raise(ActiveRecord::RecordNotUnique, "error")
      expect(app).to receive(:update_attributes).with(attrs)
      service.save_app(attrs)
    end
  end

  describe "#save_item" do
    let(:itemdata) { preview_info_source['itemdata'] }
    let(:id_str) { Baidu::App.build_id_str(itemdata['type'], itemdata['packageid'], itemdata['groupid'], itemdata['docid']) }
    let(:app) { create :baidu_app }
    it "return nil when no docid" do
      preview_info_source['itemdata'].delete('docid')
      app = service.save_item preview_info_source
      expect(app).to eq nil
    end
    it "return nil when itemdata is not Hash" do
      preview_info_source['itemdata'] = []
      app = service.save_item preview_info_source
      expect(app).to eq nil
    end
  end

  describe "#download_app" do
    it "calls api to get app" do
      expect(service.api).to receive(:get).with(:app, docid: docid).and_return(full_info_source)
      service.download_app docid
    end
    it "calls save_app_stack" do
      expect(service).to receive(:save_app_stack)
      service.download_app docid
    end
    it "write error to log" do
      allow(service).to receive(:save_app_stack).and_raise StandardError.new 'boom!'
      expect(Baidu::Log).to receive(:error)
      service.download_app docid
    end
  end

  describe "#save_app_stack" do
    context "when save app" do
      after do
        service.save_app_stack full_info_source
      end
      it { expect(service).to receive(:save_app).and_return(app) }
      it { expect(service).to receive(:save_versions) }
      it { expect(service).to receive(:save_video) }
      it { expect(service).to receive(:save_recommend_apps) }
      it { expect(service).to receive(:save_developer) }
      it { expect(service).to receive(:save_category) }
      it { expect(service).to receive(:save_tags).and_return([]) }
      it { expect(service).to receive(:save_display_tags).and_return([]) }
      it { expect(service).to receive(:save_source) }
    end

    context "when update dependencies" do
      before do
        allow(service).to receive(:save_app).and_return(app)
      end
      it "updates developer" do
        developer = create :baidu_developer
        allow(service).to receive(:save_developer).and_return(developer)
        service.save_app_stack full_info_source
        expect(app.reload.developer).to eq developer
      end
      it "update category" do
        cat = create :baidu_category
        allow(service).to receive(:save_category).and_return(cat)
        service.save_app_stack full_info_source
        expect(app.reload.category).to eq cat
      end
      it "update tags" do
        tags = create_list :baidu_tag, 2
        allow(service).to receive(:save_tags).and_return(tags)
        service.save_app_stack full_info_source
        expect(app.reload.tags).to match_array tags
      end
      it "update display tags" do
        tags = create_list :baidu_display_tag, 2
        allow(service).to receive(:save_display_tags).and_return(tags)
        service.save_app_stack full_info_source
        expect(app.reload.display_tags).to match_array tags
      end
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
    context "when video hash exists" do
      before :each do
        VCR.use_cassette("baidu/get_app--with-video") do
          service.api.get :app, docid: 9921562
        end
      end
      let(:full_info_source) { json_vcr_fixture('baidu/get_app--with-video.yml') }
      let(:base_info) { service.fetch_base_info(full_info_source) }
      it "returns video data" do
        expect(base_info['video'].is_a?(Hash)).to eq true
        expect(attrs[:videourl]).to eq base_info['video']['videourl']
        expect(attrs[:playcount]).to eq base_info['video']['playcount']
        expect(attrs[:image]).to eq base_info['video_image']
        expect(attrs[:orientation]).to eq base_info['video']['orientation']
        expect(attrs[:duration]).to eq base_info['video']['duration']
        expect(attrs[:source]).to eq base_info['video']['from']
        expect(attrs[:origin_id]).to eq base_info['video']['id']
        expect(attrs[:title]).to eq base_info['video']['title']
        expect(attrs[:packageid]).to eq base_info['video']['packageid']
      end
    end
  end

  describe "#build_tags_attrs" do
    let(:attrs) { service.build_tags_attrs(full_info_source) }
    it "returns tags data" do
      tags_attrs = base_info['apptags'].map{|name| {name: name} }
      expect(attrs).to eq tags_attrs
    end
  end

  describe "#build_display_tags_attrs" do
    let(:attrs) { service.build_display_tags_attrs(full_info_source) }
    let(:tag_display_info) { base_info['tag_display'] }
    it { expect(attrs.count).to be >= tag_display_info.count }
    context "when content field is string" do
      it "returns attrs with string content" do
        tag_source = tag_display_info.keep_if{|k, v| v['content'].is_a?(String) }.first #array
        tag = attrs.first
        expect(tag[:name]).to eq tag_source[0]
        expect(tag[:content]).to eq tag_source[1]['content']
        expect(tag[:icon]).to eq tag_source[1]['icon']
        expect(tag[:flagicon]).to eq tag_source[1]['flagicon']
      end
    end
    context "when content field is an array" do
      it "returns attrs with hash content" do
        tag_source = tag_display_info.keep_if{|k, v| v['content'].is_a?(Array) }.first #array
        tag = attrs.select{|a| !JSON.parse(a[:content_json]).empty? }.first
        expect(tag[:name]).to eq tag_source[0]
        expect(tag[:content_json]).to eq tag_source[1]['content'][0].to_json #take first json from array
        expect(tag[:icon]).to eq tag_source[1]['icon']
        expect(tag[:flagicon]).to eq tag_source[1]['flagicon']
      end
    end
  end

  describe "#save_versions" do
    let(:version_attrs) { service.build_versions_attrs(full_info_source) }
    it "saves version for app" do
      expect(app.versions.count).to eq 0
      service.save_versions(app, version_attrs)
      expect(app.versions.count).to eq version_attrs.count
    end
  end

  describe "#save_developer" do
    let(:developer_attrs) { service.build_developer_attrs(full_info_source) }
    it "saves developer" do
      developer = service.save_developer developer_attrs
      expect(developer.persisted?).to eq true
      expect(developer.origin_id.to_s).to eq developer_attrs[:origin_id]
      expect(developer.name).to eq developer_attrs[:name]
      expect(developer.score.to_s).to eq developer_attrs[:score]
      expect(developer.level.to_s).to eq developer_attrs[:level]
    end
  end

  describe "#save_category" do
    let(:category_attrs) { service.build_category_attrs(full_info_source) }
    it "saves category" do
      category = service.save_category(category_attrs)
      expect(category.persisted?).to eq true
      expect(category.origin_id.to_s).to eq category_attrs[:origin_id]
      expect(category.name.to_s).to eq category_attrs[:name]
    end
    it "ok when cat already exists" do
      category = create :baidu_category, category_attrs
      expect(category.persisted?).to eq true

      category2 = service.save_category(category_attrs)
      expect(category2.id).to eq category.id
    end
  end

  describe "#save_video" do
    let(:full_info_source) { json_fixture('static/baidu/full_info_with_video.json') }
    let(:video_attrs) { service.build_video_attrs(full_info_source) }
    it "saves video" do
      expect(app.video).to eq nil
      service.save_video(app, video_attrs)
      expect(app.video.persisted?).to eq true
      expect(app.video.origin_id.to_s).to eq video_attrs[:origin_id].to_s
      expect(app.video.title.to_s).to eq video_attrs[:title].to_s
    end
  end

  describe "#save_tags" do
    let(:tags_attrs) { service.build_tags_attrs(full_info_source) }
    it "saves tags" do
      tags = service.save_tags(tags_attrs)
      expect(tags.count).to eq tags_attrs.count
      expect(tags.map{|t| t.name}).to eq tags_attrs.map{|t| t[:name]}
    end
    it "find already created tags and return it" do
      tag_name = 'rock-n-roll'
      saved_tag = create :baidu_tag, name: tag_name
      expect(saved_tag.persisted?).to eq true
      tags_attrs << { name: tag_name }
      tags = service.save_tags(tags_attrs)
      expect(tags.map{|t| t.name}).to include tag_name
    end
  end

  describe "#save_display_tags" do
    let(:attrs) { service.build_display_tags_attrs(full_info_source) }
    it "saves tags" do
      tags = service.save_display_tags(attrs)
      expect(tags.count).to eq attrs.count
      expect(tags.first.name).to eq attrs[0][:name]
      expect(tags.first.content).to eq attrs[0][:content]
      expect(tags.first.content_json).to eq attrs[0][:content_json]
    end
  end

  # describe "#build_recommend_groups_attrs" do
  #   let(:attrs) { service.build_recommend_groups_attrs(full_info_source) }
  #   it "retruns recommend groups" do
  #     expect(attrs).to eq data_info['recommend_info'].map{|d| {name: d['recommend_title']} }
  #   end
  # end

  describe "#build_app_attrs" do
    let(:attrs) { service.build_app_attrs(full_info_source) }
    let(:base_info) { service.fetch_base_info full_info_source }
    it "fixes names of few fields" do
      expect(attrs['today_str_download']).to eq base_info['today_strDownload']
      expect(attrs['now_download']).to eq base_info['nowDownload']
      expect(attrs['app_type']).to eq base_info['type']
    end
    it "keep all fields of app model" do
      keys =  base_info.keep_if {|a| Baidu::App.column_names.include?(a.to_s)}.keys
      keys = keys + ['today_str_download', 'now_download', 'app_type']
      expect(attrs.keys).to match_array keys
    end
  end

  describe "#build_recommend_apps_attrs" do
    let(:attrs) { service.build_recommend_apps_attrs(full_info_source) }
    it "returns not empty list" do
      expect(attrs.count).to be > 0
    end
    it "retruns recommend app data" do
      app = attrs[0]
      expect(app[:group_name]).to_not eq nil
      expect(app[:sname]).to_not eq nil
      expect(app[:app_type]).to_not eq nil
      expect(app[:packageid]).to_not eq nil
      expect(app[:docid]).to_not eq nil
      expect(app[:recommend]).to_not eq nil
    end
  end

  describe "#save_recommend_apps" do
    let(:attrs) do
      [{
        sname: 'yeah!',
        group_name: 'rock-n-roll',
        app_type: 'game',
        packageid: 1,
        groupid: 2,
        docid: 3,
        recommend: 'cool game!'
      }]
    end
    let(:app) { create :baidu_app }
    let(:group) { Baidu::RecommendGroup.where(name: attrs[0][:group_name]).first }
    before do
      service.save_recommend_apps(app, attrs)
    end
    it "saves recommend apps" do
      expect(app.recommend_apps.count).to be > 0
    end
    it "creates group with group_name" do
      expect(group.persisted?).to eq true
    end
    it "saves attrs of app correctly" do
      app_attrs = attrs.first
      recommend_app = app.recommend_apps.first
      expect(recommend_app.app_type).to eq app_attrs[:app_type]
      expect(recommend_app.packageid).to eq app_attrs[:packageid]
      expect(recommend_app.groupid).to eq app_attrs[:groupid]
      expect(recommend_app.docid).to eq app_attrs[:docid]
      expect(recommend_app.recommend).to eq app_attrs[:recommend]
      expect(recommend_app.recommend_group).to eq group
      expect(recommend_app.sname).to eq app_attrs[:sname]
    end
  end

  describe "#build_source_attrs" do
    let(:attrs) { service.build_source_attrs full_info_source }
    it { expect(attrs[:name]).to_not eq nil }
  end

  describe "#save_source" do
    let(:attrs) do
      { name: 'baidu store' }
    end
    it "saves source" do
      result = service.save_source attrs
      expect(result.is_a?(Baidu::Source)).to eq true
      expect(result.persisted?).to eq true
    end
  end
end
