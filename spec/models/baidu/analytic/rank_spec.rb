require 'rails_helper'

RSpec.describe Baidu::Analytic::Rank do
  let(:service) { Baidu::Analytic::Rank }

  describe ".ranks_count_by_board" do
    let(:rank_type) { Baidu::Rank::FEATURE_IN_BOARD_RANK }
    context "by rank_type" do
      let(:day) { Date.today }
      let!(:rank1) { create_list :baidu_rank, 2, rank_type: rank_type, day: day, info: { board_id: 1 }}
      let!(:rank2) { create_list :baidu_rank, 5, rank_type: rank_type, day: day, info: { board_id: 2 }}
      let!(:rank3) { create_list :baidu_rank, 1, rank_type: 'other', day: day, info: { board_id: 2 }}
      it "returns ranks count grouped by board_id" do
        result = service.count_by_board rank_type, day
        expect(result.count).to eq 2
        expect(result.select{|h| h['board_id'] == '1'}[0]['count']).to eq '2'
        expect(result.select{|h| h['board_id'] == '2'}[0]['count']).to eq '5'
      end
    end
    context "by day" do
      let(:day) { Date.today }
      let!(:rank1) { create_list :baidu_rank, 5, rank_type: rank_type, day: day, info: { board_id: 1 }}
      let!(:rank2) { create_list :baidu_rank, 2, rank_type: rank_type, day: Date.yesterday, info: { board_id: 2 }}
      it "returns ranks count grouped by board_id" do
        result = service.count_by_board rank_type, day
        expect(result.count).to eq 1
        expect(result.select{|h| h['board_id'] == '1'}[0]['count']).to eq '5'
      end
    end
  end
end
