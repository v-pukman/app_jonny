require 'rails_helper'

RSpec.describe Baidu::ApiClient do
  let(:client) { Baidu::ApiClient.new }

  before do
    RedisClient.flushdb
  end

  describe "get_app" do
    let(:docid) { 9723881 }
    context "with default uid" do
      before do
        allow(client).to receive(:default_params).with(:details).and_return(client.send(:original_default_params, :details))
      end
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
    xit "returns app info with replcaced uid in params" do
      File.write(Rails.root.join("fixtures", "vcr", "baidu","get_app--generated-uid.yml"), "")
      VCR.use_cassette("baidu/get_app--generated-uid", record: :new_episodes) do
        res = client.get_app({ docid: docid })
        expect(res["result"]["data"]["base_info"]["docid"].to_i).to eq docid
      end
    end
  end

  describe "get_comments" do
    let(:docid) { 9945457 }
    let(:groupid) { 4003077 }
    let(:start) { 0 }
    let(:count) { 10 }
    let(:options) do
      { docid: docid, groupid: groupid, start: start, count: count }
    end
    before do
      allow(client).to receive(:default_params).with(:comments).and_return(client.send(:original_default_params, :comments))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_comments") do
        res = client.get_comments options
        expect(res).to_not eq nil
      end
    end
    it "returns list of comments" do
      VCR.use_cassette("baidu/get_comments") do
        res = client.get_comments options
        expect(res["data"].count).to be > 0
        expect(res["data"][0]["thread_id"].to_i).to eq groupid
        expect(res["data"][0]["reply_id"]).to_not eq nil
        expect(res["data"][0]["content"]).to_not eq nil
      end
    end
  end

  describe "get_search" do
    let(:word) { '斗地主' }
    let(:pn) { 0 }
    let(:options) do
      { word: word, pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:search).and_return(client.send(:original_default_params, :search))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_search") do
        res = client.get_search options
        expect(res).to_not eq nil
      end
    end
    it "returns list of apps" do
      VCR.use_cassette("baidu/get_search") do
        res = client.get_search options
        expect(res["result"]["data"].count).to be > 0
        expect(res["result"]["data"][0]["itemdata"]["docid"]).to_not eq nil
        expect(res["result"]["data"][0]["itemdata"]["sname"]).to_not eq nil
        expect(res["result"]["data"][1]["itemdata"]["docid"]).to_not eq nil
        expect(res["result"]["data"][1]["itemdata"]["sname"]).to_not eq nil
      end
    end
    it "returns next page" do
      VCR.use_cassette("baidu/get_search") do
        res = client.get_search options
        res_ids = res["result"]["data"].map{|i| i["itemdata"]["docid"].to_i}
        VCR.use_cassette("baidu/get_search_page2") do
          options[:pn] += 1
          res2 = client.get_search options
          res2_ids = res2["result"]["data"].map{|i| i["itemdata"]["docid"].to_i}
          expect(res_ids&res2_ids).to eq []
        end
      end
    end
  end

  describe "#get_board" do
    let(:boardid) { 'board_100_0105' }
    let(:sorttype) { 'game' }
    let(:pn) { 0 }
    let(:options) do
      { boardid: boardid, sorttype: sorttype, pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:board).and_return(client.send(:original_default_params, :board))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_board") do
        res = client.get_board options
        expect(res).to_not eq nil
      end
    end
    it "returns list of board games" do
      VCR.use_cassette("baidu/get_board") do
        res = client.get_board options
        expect(res["result"]["data"].count).to be > 0
        expect(res["result"]["data"].map{|i| i["itemdata"]["docid"] }.compact.count).to be > 0
      end
    end
  end

  describe "#get_featured_board" do
    let(:board) { 'board_100_790' }
    let(:pn) { 0 }
    let(:options) do
      { board: board, pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:featured_board).and_return(client.send(:original_default_params, :featured_board))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_featured_board") do
        res = client.get_featured_board options
        expect(res).to_not eq nil
      end
    end
    it "returns list of ranked apps" do
      VCR.use_cassette("baidu/get_featured_board") do
        res = client.get_featured_board options
        items = res["result"]["data"].select {|i| i.is_a?(Hash) && i['itemdata']["docid"] }
        expect(items.count).to be > 0
        expect(items[0]['itemdata']['rankingnum']).to_not eq nil
      end
    end
  end

  describe "#get_boards" do
    let(:sorttype) { 'soft' }
    let(:options) do
      { sorttype: sorttype }
    end
    before do
      allow(client).to receive(:default_params).with(:boards).and_return(client.send(:original_default_params, :boards))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_boards--soft") do
        res = client.get_boards options
        expect(res).to_not eq nil
      end
    end
    it "returns links to boards" do
      VCR.use_cassette("baidu/get_boards--soft") do
        res = client.get_boards options
        expect(res["result"]["data"][0]["itemdata"].last["dataurl"]).to include "&boardid="
      end
    end
  end

  describe "get_ranks" do
    let(:action) { 'risingrank' }
    let(:pn) { 0 }
    let(:options) do
      { action: action, pn: 0 }
    end
    before do
      allow(client).to receive(:default_params).with(:ranks).and_return(client.send(:original_default_params, :ranks))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_ranks") do
        res = client.get_ranks options
        expect(res).to_not eq nil
      end
    end
    it "returns list of games with ranknumber" do
      VCR.use_cassette("baidu/get_ranks--rising") do
        res = client.get_ranks options
        items = res["result"]["data"].select {|i| i.is_a?(Hash) && i["datatype"].to_i == 348 }
        expect(items[0]["itemdata"]["docid"]).to_not eq nil
        expect(items[0]["itemdata"]["rankingnum"]).to_not eq nil
        expect(items[0]["itemdata"]["rise_percent"]).to_not eq nil
      end
    end
    context "when top ranks type" do
      let(:action) { 'ranktoplist' }
      it "returns list of games with heat value" do
        VCR.use_cassette("baidu/get_ranks--top") do
          res = client.get_ranks options
          items = res["result"]["data"].select {|i| i.is_a?(Hash) && i["datatype"].to_i == 346 }
          expect(items[0]["itemdata"]["docid"]).to_not eq nil
          expect(items[0]["itemdata"]["rankingnum"]).to_not eq nil
          expect(items[0]["itemdata"]["heat_value"]).to_not eq nil
        end
      end
    end
  end

  describe "get_featured" do
    let(:pn) { 0 }
    let(:options) do
      { pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:featured).and_return(client.send(:original_default_params, :featured))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_featured") do
        res = client.get_featured options
        expect(res).to_not eq nil
      end
    end
    it "returns list with feature-boards and small list of games" do
      VCR.use_cassette("baidu/get_featured") do
        res = client.get_featured options
        boards = res["result"]["data"].select {|i| i.is_a?(Hash) && i["datatype"] == 339 }
        expect(boards[0]["itemdata"]["dataurl"]).to include "action=featureboard&board="
        games = res["result"]["data"].select {|i| i.is_a?(Hash) && i["datatype"] == 341 }
        expect(games[0]["itemdata"]["docid"]).to_not eq nil
      end
    end
  end

  describe "get_game_ranks" do
    let(:pn) { 0 }
    let(:options) do
      { pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:game_ranks).and_return(client.send(:original_default_params, :game_ranks))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_game_ranks") do
        res = client.get_game_ranks options
        expect(res).to_not eq nil
      end
    end
    it "returns list of boards and small list of games" do
      VCR.use_cassette("baidu/get_game_ranks") do
        res = client.get_game_ranks options
        blocks = res["result"]["data"].select{|i| i["datatype"] == 329 }
        expect(blocks[0]["itemdata"]["groupheader"]).to_not eq nil
        expect(blocks[0]["itemdata"]["groupapp"]).to_not eq nil
      end
    end
    context "when board_id is passed" do
      let(:board_id) { 'board_102_736' }
      let(:options) do
        { pn: pn, board_id: board_id }
      end
      it "returns list of ranked games in this board" do
        VCR.use_cassette("baidu/get_game_ranks--in-board") do
          res = client.get_game_ranks options
          games = res["result"]["data"].select{|i| i["datatype"] == 330 }
          expect(games.count).to be > 0
          expect(games[0]["itemdata"]["docid"]).to_not eq nil
        end
      end
    end
  end

  describe "get_soft_ranks" do
    let(:pn) { 0 }
    let(:options) do
      { pn: pn }
    end
    before do
      allow(client).to receive(:default_params).with(:soft_ranks).and_return(client.send(:original_default_params, :soft_ranks))
    end
    it "returns result" do
      VCR.use_cassette("baidu/get_soft_ranks") do
        res = client.get_soft_ranks options
        expect(res).to_not eq nil
      end
    end
    it "has soft apps data" do
      VCR.use_cassette("baidu/get_soft_ranks") do
        res = client.get_soft_ranks options
        apps = res['result']['data']
        expect(apps.length).to be > 0
        expect(apps[0]['itemdata']['docid']).to_not eq nil
        expect(apps[0]['itemdata']['type']).to eq 'soft'
        expect(apps[0]['itemdata']['rankingnum']).to_not eq nil
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

  describe "#generate_uid" do
    it "has right length" do
      uid = client.send :generate_uid, 69
      expect(uid.length).to eq 69
    end
  end

  describe "#original_default_params" do
    it "returns original default params hash" do
      params = client.send :original_default_params, :search
      expect(params).to eq ::Baidu::DefaultParams.search
    end
  end

  describe "#default_params" do
    let(:uid) { client.send(:generate_uid, 69) }
    it "returns default params hash" do
      expect(::Baidu::DefaultParams).to receive(:details).and_return(::Baidu::DefaultParams.details)
      params = client.send :default_params, :details
      expect(params).to_not eq nil
    end
    it "generate new uid and replace it" do
      allow(client).to receive(:generate_uid).and_return(uid)
      params = client.send :default_params, :details
      expect(params['uid']).to eq uid
      expect(params['pu']).to include "cuid@#{uid[0...42]}"
    end
    it "changes pu value" do
      original_pu = ::Baidu::DefaultParams.details['pu']
      params = client.send :default_params, :details
      expect(params['pu']).to_not eq original_pu
    end
  end
end
