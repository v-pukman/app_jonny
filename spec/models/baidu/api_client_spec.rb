require 'rails_helper'

RSpec.describe Baidu::ApiClient do
  let(:client) { Baidu::ApiClient.new }
  it "makes request" do
    VCR.use_cassette("baidu/make_request") do
      res = client.make_request 'https://api.github.com/users/hackeryou', {}, {}
      expect(res).to_not eq nil
      expect(res["login"]).to eq 'HackerYou'
    end
  end

  describe "get_app" do
    let(:docid) { 9723881 }
    it "returns app info by its docid" do
      VCR.use_cassette("baidu/get_app") do
        res = client.get_app docid
        expect(res).to_not eq nil
        expect(res['result']['data']['docid'].to_i).to eq docid
      end
    end
  end
end
