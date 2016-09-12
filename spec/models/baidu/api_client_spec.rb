require 'rails_helper'

RSpec.describe Baidu::ApiClient do
  let(:client) { Baidu::ApiClient.new }

  before do
    RedisClient.flushdb
  end

  describe "get_app" do
    let(:docid) { 9723881 }
    it "returns result" do
      VCR.use_cassette("baidu/get_app") do
        res = client.get_app({ docid: docid })
        expect(res).to_not eq nil
      end
    end
    it "returns app info" do
      VCR.use_cassette("baidu/get_app") do
        res = client.get_app({ docid: docid })
        expect(res["result"]["data"]["base_info"]["docid"].to_i).to eq docid
      end
    end
  end

  describe "#get" do
    it "calls method" do
      expect(client).to receive(:get_app).with({docid: 123})
      client.get :app, docid: 123
    end
    it "raises error on not imlemented" do
      expect { client.get(:zzzz, {}) }.to raise_error NotImplementedError
    end
  end

  describe "#get_option" do
    it "raises error if no option" do
      expect { client.send(:get_option, {}, :option_name) }.to raise_error ArgumentError
    end
    it "returns value" do
      expect(client.send(:get_option, { app_id: 123 }, :app_id)).to eq 123
    end
  end

  describe "#cache_key" do
    it "returns key" do
      expect(client.send(:cache_key, :foo, app_id: 1, source: 2)).to eq "baidu_client:foo:{:app_id=>1, :source=>2}"
    end
  end

  describe "#handle_caching" do
    let(:method) { :foo }
    let(:options) { { app_id: 2 } }
    let(:key) { client.send(:cache_key, method, options) }

    it "set data" do
      RedisClient.del(key)
      expect(RedisClient.get(key)).to eq nil
      client.send :handle_caching, method, options do
        {rocking: 'yes'}
      end
      expect(RedisClient.get(key)).to eq({rocking: 'yes'}.to_json)
    end

    it "get data" do
      RedisClient.set(key, {tested_code: 'right'}.to_json)
      result = client.send :handle_caching, method, options do
      end
      expect(result).to eq({'tested_code' => 'right'})
    end
  end
end
