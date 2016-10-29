require 'rails_helper'

RSpec.describe Baidu::Service::Board do
  let(:boards_info) { json_vcr_fixture('baidu/get_boards--soft.yml') }
  let(:service) { Baidu::Service::Board.new }

  it "has app_service" do
    expect(service.app_service.class).to eq Baidu::Service::App
  end

  describe "#save_boards" do
    let(:link1) { 'appsrv?native_api=1&sorttype=soft&boardid=board_100_10014&action=generalboard' }
    let(:link2) { 'appsrv?native_api=1&action=generalboard&boardid=board_100_019&subcateurl=true&sorttype=soft' }
    let(:attrs) do
      [
        { link: link1 },
        { link: link2 }
      ]
    end
    it "saves board records" do
      service.save_boards attrs
      board2 = Baidu::Board.where(link: link2).first
      expect(board2.persisted?).to eq true
      expect(board2.link).to eq link2
    end
  end

  describe "#download_boards" do
    let(:game_boards) { json_vcr_fixture('baidu/get_boards--game.yml')}
    let(:soft_boards) { json_vcr_fixture('baidu/get_boards--soft.yml')}
    before do
      allow(service.api).to receive(:get).with(:boards, sorttype: 'soft').and_return(game_boards)
      allow(service.api).to receive(:get).with(:boards, sorttype: 'game').and_return(game_boards)
    end
    it "call api to download soft and game boards" do
      expect(service.api).to receive(:get).with(:boards, sorttype: 'soft').and_return(game_boards)
      expect(service.api).to receive(:get).with(:boards, sorttype: 'game').and_return(soft_boards)
      service.download_boards
    end
    it "saves game and soft boards" do
      service.download_boards
      expect(Baidu::Board.where(sort_type: Baidu::App::SOFT_APP).count).to be > 0
      expect(Baidu::Board.where(sort_type: Baidu::App::GAME_APP).count).to be > 0
    end
  end

  describe "#build_boards_attrs" do
    let(:attrs) { service.build_boards_attrs boards_info }
    it "retruns board attrs" do
      expect(attrs.count).to be > 0
      attrs.each do |a|
        expect(a[:link]).to include 'appsrv?'
        expect(a[:link]).to include '&board'
        expect(a[:link]).to include '&action='
      end
    end
  end

  describe "#download_apps" do
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
      expect(service.app_service).to receive(:save_item).at_least(:once)
      service.download_apps board
    end
  end

  describe "#download_game_rank_boards" do
    let(:game_ranks) { json_vcr_fixture('baidu/get_game_ranks.yml') }
    before do
      allow(service.api).to receive(:get).with(:game_ranks, pn: 0).and_return(game_ranks)
    end
    it "calls api_cliet game_ranks method" do
      expect(service.api).to receive(:get).with(:game_ranks, pn: 0)
      service.download_game_rank_boards
    end
    it "creates boards with ranklist type" do
      service.download_game_rank_boards
      expect(Baidu::Board.ranklist.count).to be >= 4
    end
  end

  describe "#download_feature_boards" do
    let(:featured_page) { json_vcr_fixture('baidu/get_featured.yml') }
    before do
      allow(service.api).to receive(:get).with(:featured, pn: 0).and_return(featured_page)
    end
    it "calls api_cliet featured method" do
      expect(service.api).to receive(:get).with(:featured, pn: 0)
      service.download_feature_boards
    end
     it "creates boards with feature type" do
      service.download_feature_boards
      expect(Baidu::Board.featureboard.count).to be >= 3
    end
  end
end
