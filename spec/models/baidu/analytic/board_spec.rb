require 'rails_helper'

RSpec.describe Baidu::Analytic::Board do
  let(:service) { Baidu::Analytic::Board }

  describe ".count_by_type" do
    let!(:board1) { create_list :baidu_board, 2, action_type: Baidu::Board::GENERAL_BOARD }
    let!(:board2) { create :baidu_board, action_type: Baidu::Board::RANKLIST_BOARD }
    it "returns count of boards grouped by type" do
      result = service.count_by_type
      expect(result.select{|h| h['action_type'] == Baidu::Board::GENERAL_BOARD }[0]['count']).to eq '2'
      expect(result.select{|h| h['action_type'] == Baidu::Board::RANKLIST_BOARD }[0]['count']).to eq '1'
    end
  end
end
