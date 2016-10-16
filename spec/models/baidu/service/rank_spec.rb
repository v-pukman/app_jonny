require 'rails_helper'

RSpec.describe Baidu::Service::Rank do
  let(:service) { Baidu::Service::Rank.new }
  let(:preview_info) { json_fixture('static/baidu/preview_info--with-rank.json') }
  let(:soft_ranks_source) { json_vcr_fixture('baidu/get_soft_ranks.yml') }
  let(:game_ranks_source) { json_vcr_fixture('baidu/get_game_ranks.yml') }
  let(:game_ranks_in_board) { json_vcr_fixture('baidu/get_game_ranks--in-board.yml') }
  let(:rank_type) {  Baidu::Rank::SOFT_COMMON_RANK }

  it { expect(service.app_service.class).to eq Baidu::Service::App }

  describe "#build_rank_attrs" do
    let(:attrs) { service.build_rank_attrs preview_info, rank_type }
    it "returns rank attrs" do
      expect(attrs[:rank_type]).to eq rank_type
      expect(attrs[:day]).to eq Date.today
      expect(attrs[:rank_number]).to eq preview_info['itemdata']['rankingnum']
    end
  end

  describe "#save_rank" do
    let(:rank_number) { 5 }
    let(:today) { Date.today }
    let(:rank_attrs) do
      {
        rank_type: rank_type,
        day: today,
        rank_number: rank_number
      }
    end
    let(:app) { create :baidu_app }
    it "saves rank record" do
      rank = service.save_rank app, rank_attrs
      expect(rank.persisted?).to eq true
      expect(rank.rank_number).to eq rank_number
      expect(rank.day).to eq today
      expect(rank.rank_type).to eq rank_type
      expect(rank.app).to eq app
    end
    context "when ranks already saved" do
      it "returns saved rank" do
        rank = service.save_rank app, rank_attrs
        rank2 = service.save_rank app, rank_attrs
        expect(rank2).to eq rank
      end
    end
  end

  describe "#download_soft_ranks" do
    let(:items_count) { soft_ranks_source['result']['data'].count }
    before do
      allow(service.api).to receive(:get).with(:soft_ranks, pn: 0).and_return(soft_ranks_source)
      allow(service.api).to receive(:get).with(:soft_ranks, pn: 1).and_return({ 'result' => { 'data' => [] } })
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_soft_ranks
    end
    it "calls save_rank" do
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
      expect(service).to receive(:save_rank).at_least(items_count).times
      service.download_soft_ranks
    end
  end

  describe "#download_game_ranks_in_board" do
    let(:items_count) { game_ranks_in_board['result']['data'].count }
    let(:board) { create :baidu_board, action_type: 'ranklist' }
    before do
      allow(service.api).to receive(:get).with(:game_ranks, board_id: board.origin_id, pn: 0).and_return(game_ranks_in_board)
      allow(service.api).to receive(:get).with(:game_ranks, board_id: board.origin_id, pn: 1).and_return({ 'result' => { 'data' => [] } })
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_game_ranks_in_board board
    end
    it "calls save_rank" do
      expect(service).to receive(:save_rank).at_least(items_count).times
      service.download_game_ranks_in_board board
    end
    it "returns nil if board is not ranklist type" do
      board = create :baidu_board, action_type: 'any_other'
      result = service.download_game_ranks_in_board board
      expect(result).to eq nil
      expect(service.app_service).to_not receive(:save_item)
    end
  end
end
