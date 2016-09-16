require 'rails_helper'

RSpec.describe Baidu::Service do
  include_context "baidu_api_client_with_default_params"

  let!(:service) { Baidu::Service.new }
  let(:preview_info_source) { json_fixture('baidu/preview_info_source--doudizhu.json') }
  let(:full_info_source) { json_vcr_fixture('baidu/get_app--for-save-app.yml') }

  it { expect(preview_info_source).to_not eq nil }
  it { expect(service.api.is_a?(Baidu::ApiClient)).to eq true }

  describe "#save_app" do
    let(:data) { full_info_source['result']['data']['base_info'] }
    context "when app is not saved in db" do
      it "saves new app" do
        VCR.use_cassette("baidu/get_app--for-save-app") do
          app = service.save_app(preview_info_source)
          expect(app.persisted?).to eq true
        end
      end
      it "fixes wrong keys" do
        VCR.use_cassette("baidu/get_app--for-save-app") do
          app = service.save_app(preview_info_source)
          expect(app.today_str_download.to_s).to eq data['today_strDownload']
          expect(app.now_download.to_s).to eq data['nowDownload']
          expect(app.app_type).to eq data['type']
        end
      end
      # sometimes group or packageid can be blank
      # in this case app didnt found in first time
      # but after full info downloaded must be found and updated
      it "check existing of app again after full_info loading" do
        VCR.use_cassette("baidu/get_app--for-save-app") do
          app = create :baidu_app, app_type: data['type'], packageid: data['packageid'], groupid: data['groupid'], docid: data['docid']
          expect(app.persisted?).to eq true
          expect(app.sname).to eq nil

          preview_info_source['itemdata'].delete('groupid')
          new_app = service.save_app(preview_info_source)

          expect(new_app.id).to eq app.id
          expect(new_app.sname).to eq data['sname']
        end
      end

      it "updated record when RecordNotUnique db error raised" do
      end
    end
  end
end
