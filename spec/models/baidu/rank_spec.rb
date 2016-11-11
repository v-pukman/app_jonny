require 'rails_helper'

RSpec.describe Baidu::Rank, type: :model do
  let(:rank) { create :baidu_rank }

  it "has a factory" do
    expect(rank.persisted?).to eq true
  end

  context "not valid when" do
    # disabled
    xit "app_id and day and rank_type already saved" do
      app = create :baidu_app
      day = '2016-01-01'
      rank_type = Baidu::Rank::SOFT_COMMON_RANK
      rank1 = create :baidu_rank, app: app, day: day, rank_type: rank_type
      rank2 = build :baidu_rank, app: app, day: day, rank_type: rank_type
      expect(rank2.valid?).to eq false
      expect(rank2.errors[:app_id]).to_not eq []
    end
  end

  context "info" do
    it "can find by info board_id" do
      rank1 = create :baidu_rank, info: { board_id: 1 }
      rank2 = create :baidu_rank, info: { board_id: 5 }
      result = Baidu::Rank.where('info @> ?', {board_id: 1}.to_json).first
      expect(result).to eq rank1
    end
  end

  describe ".ranks_count_by_board" do
    let(:rank_type) { Baidu::Rank::FEATURE_IN_BOARD_RANK }
    context "by rank_type" do
      let(:day) { Date.today }
      let!(:rank1) { create_list :baidu_rank, 2, rank_type: rank_type, day: day, info: { board_id: 1 }}
      let!(:rank2) { create_list :baidu_rank, 5, rank_type: rank_type, day: day, info: { board_id: 2 }}
      let!(:rank3) { create_list :baidu_rank, 1, rank_type: 'other', day: day, info: { board_id: 2 }}
      it "returns ranks count grouped by board_id" do
        result = Baidu::Rank.ranks_count_by_board rank_type, day
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
        result = Baidu::Rank.ranks_count_by_board rank_type, day
        expect(result.count).to eq 1
        expect(result.select{|h| h['board_id'] == '1'}[0]['count']).to eq '5'
      end
    end
  end
end
