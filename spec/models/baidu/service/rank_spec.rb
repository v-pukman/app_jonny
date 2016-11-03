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
    context "when preview_info has additional info" do
      let(:heat_value) { 500 }
      let(:rise_percent) { "397.9%" }
      let(:rise_percent_num) { 397.9 }
      before do
        preview_info['itemdata']['heat_value'] = heat_value
        preview_info['itemdata']['rise_percent'] = rise_percent
      end
      let(:attrs) { service.build_rank_attrs preview_info, rank_type }
      it { expect(attrs[:info][:heat_value]).to eq heat_value }
      it { expect(attrs[:info][:rise_percent]).to eq rise_percent_num }
    end
    it "merges info data" do
      attrs = service.build_rank_attrs preview_info, rank_type, { language: 'ruby' }
      expect(attrs[:info][:language]).to eq 'ruby'
    end
    context "when preview_info has app info in app_data" do
      let(:preview_info_349) { json_fixture('static/baidu/preview_info--datatype-349.json') }
      let(:attrs) { service.build_rank_attrs preview_info_349, rank_type }
      it { expect(attrs[:rank_number]).to_not eq nil }
    end
  end

  describe "#save_rank" do
    let(:rank_number) { 5 }
    let(:today) { Date.today }
    let(:rank_attrs) do
      {
        rank_type: rank_type,
        day: today,
        rank_number: rank_number,
        info: {}
      }
    end
    let(:board_id) { 1 }
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
      it "prevents duplication by day, rank_type" do
        rank = service.save_rank app, rank_attrs
        rank2 = service.save_rank app, rank_attrs
        expect(rank2).to eq rank
      end
      it "prevents duplication by day, rank_type, and board_id" do
        attrs_no_info = { rank_type: rank_type, day: today, rank_number: rank_number }
        attrs_with_info = { rank_type: rank_type, day: today, rank_number: rank_number, info: { board_id: board_id } }

        rank1 = create :baidu_rank, attrs_no_info.merge(app: app)
        rank2 = create :baidu_rank, attrs_no_info.merge(app: app)
        rank3 = create :baidu_rank, attrs_with_info.merge(app: app)

        rank = service.save_rank app, attrs_with_info
        expect(rank.id).to eq rank3.id
      end
    end
  end

  context "when soft_ranks" do
    let(:rank_type) { Baidu::Rank::SOFT_COMMON_RANK }
    let(:items_count) { soft_ranks_source['result']['data'].count }
    before do
      allow(service.api).to receive(:get).with(:soft_ranks, pn: 0).and_return(soft_ranks_source)
      allow(service.api).to receive(:get).with(:soft_ranks, pn: 1).and_return({ 'result' => { 'data' => [] } })
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_ranks rank_type
    end
    it "calls save_rank" do
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
      expect(service).to receive(:save_rank).at_least(items_count).times
      service.download_ranks rank_type
    end
  end

  context "#when game_ranks_in_board" do
    let(:rank_type) { Baidu::Rank::GAMES_IN_BOARD_RANK }
    let(:items_count) { game_ranks_in_board['result']['data'].count }
    let(:board) { create :baidu_board, action_type: 'ranklist' }
    before do
      allow(service.api).to receive(:get).with(:game_ranks, board_id: board.origin_id, pn: 0).and_return(game_ranks_in_board)
      allow(service.api).to receive(:get).with(:game_ranks, board_id: board.origin_id, pn: 1).and_return({ 'result' => { 'data' => [] } })
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_ranks rank_type, board: board
    end
    it "calls save_rank" do
      expect(service).to receive(:save_rank).at_least(items_count).times
      service.download_ranks rank_type, board: board
    end
    it "returns nil if board is not ranklist type" do
      board = create :baidu_board, action_type: 'any_other'
      service.download_ranks rank_type, board: board
      expect(Log.errors.last.message).to eq "Board is invalid"
      expect(Log.errors.last.context['options']['board']['id']).to eq board.id
    end
  end

  context "when top_ranks" do
    let(:rank_type) { Baidu::Rank::TOP_RANK }
    let(:ranks_source) { json_vcr_fixture('baidu/get_ranks--top.yml') }
    let(:items_count) { ranks_source['result']['data'].count }
    before do
      allow(service.api).to receive(:get).with(:ranks, action: 'ranktoplist', pn: 0).and_return(ranks_source)
      allow(service.api).to receive(:get).with(:ranks, action: 'ranktoplist', pn: 1).and_return({ 'result' => { 'data' => [] } })
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
    end
    it "calls api to get ranks" do
      expect(service.api).to receive(:get).with(:ranks, action: 'ranktoplist', pn: 0).at_least(1).times
      service.download_ranks rank_type
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_ranks rank_type
    end
    it "calls save_rank" do
      expect(service).to receive(:save_rank).at_least(1).times
      service.download_ranks rank_type
    end
  end

  context "when rising_ranks" do
    let(:rank_type) { Baidu::Rank::RISING_RANK }
    let(:ranks_source) { json_vcr_fixture('baidu/get_ranks--rising.yml') }
    let(:items_count) { ranks_source['result']['data'].count }
    before do
      allow(service.api).to receive(:get).with(:ranks, action: 'risingrank', pn: 0).and_return(ranks_source)
      allow(service.api).to receive(:get).with(:ranks, action: 'risingrank', pn: 1).and_return({ 'result' => { 'data' => [] } })
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
    end
    it "calls api to get ranks" do
      expect(service.api).to receive(:get).with(:ranks, action: 'risingrank', pn: 0).at_least(1).times
      service.download_ranks rank_type
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_ranks rank_type
    end
    it "calls save_rank" do
      expect(service).to receive(:save_rank).at_least(1).times
      service.download_ranks rank_type
    end
  end

  context "when featured_board ranks" do
    let(:board) { create :baidu_board, origin_id: 'board_100_790', action_type: Baidu::Board::FEATURE_BOARD }
    let(:rank_type) { Baidu::Rank::FEATURE_IN_BOARD_RANK }
    let(:ranks_source) { json_vcr_fixture('baidu/get_featured_board.yml') }
    let(:items_count) { ranks_source['result']['data'].count }
    before do
      allow(service.api).to receive(:get).with(:featured_board, board: board.origin_id, pn: 0).and_return(ranks_source)
      allow(service.api).to receive(:get).with(:featured_board, board: board.origin_id, pn: 1).and_return({ 'result' => { 'data' => [] } })
      allow(service.app_service).to receive(:save_item).and_return(create(:baidu_app))
    end
    it "calls api to get ranks" do
      expect(service.api).to receive(:get).with(:featured_board, board: board.origin_id, pn: 0).at_least(1).times
      service.download_ranks rank_type, board: board
    end
    it "calls app_service to save_item" do
      expect(service.app_service).to receive(:save_item).at_least(items_count).times
      service.download_ranks rank_type, board: board
    end
    it "calls save_rank" do
      expect(service).to receive(:save_rank).at_least(1).times
      service.download_ranks rank_type, board: board
    end
    it "returns nil if board is not ranklist type" do
      board = create :baidu_board, action_type: 'any_other'
      service.download_ranks rank_type, board: board
      expect(Log.errors.last.message).to eq "Board is invalid"
      expect(Log.errors.last.context['options']['board']['id']).to eq board.id
    end
  end
end
