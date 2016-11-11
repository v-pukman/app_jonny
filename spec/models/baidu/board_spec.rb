require 'rails_helper'

RSpec.describe Baidu::Board, type: :model do
  let(:board_id) { "board_100_500" }
  let(:action) { "megaboard" }
  let(:link) { "appsrv?boardid=#{board_id}&action=#{action}&sorttype=game" }
  let(:link_var2) { "appsrv?board=#{board_id}&action=#{action}&sorttype=soft" }
  let(:board) { create :baidu_board }

  it "has a factory" do
    expect(board.persisted?).to eq true
  end

  it "has .generalboard scope" do
    board1 = create :baidu_board, action_type: 'generalboard'
    board2 = create :baidu_board, action_type: 'any_other'
    expect(Baidu::Board.generalboard).to eq [board1]
  end

  it "has .ranklist scope" do
    board1 = create :baidu_board, action_type: 'generalboard'
    board2 = create :baidu_board, action_type: 'ranklist'
    expect(Baidu::Board.ranklist).to eq [board2]
  end

  context "not valid when" do
    it "has empty link" do
      board = build :baidu_board, link: nil
      board.valid?
      expect(board.errors[:link]).to_not eq []
    end
    it "has not uniq link" do
      board = create :baidu_board
      board2 = build :baidu_board, link: board.link
      board2.valid?
      expect(board2.errors[:link]).to_not eq []
    end
  end

  describe "#set_params" do
    context "origin_id" do
      it "set origin_id from boardid param" do
        board = create :baidu_board, link: link
        expect(board.origin_id).to eq board_id
      end
      it "set origin_id from board param" do
        board = create :baidu_board, link: link_var2
        expect(board.origin_id).to eq board_id
      end
    end
    it "set action_type" do
      board = create :baidu_board, link: link
      expect(board.action_type).to eq action
    end
    it "set sort_type" do
      board = create :baidu_board, link: link
      board2 = create :baidu_board, link: link_var2
      expect(board.sort_type).to eq 'game'
      expect(board2.sort_type).to eq 'soft'
    end
  end

  describe "#link_params" do
    it "split link to params hash" do
      board = build :baidu_board, link: link
      params = board.link_params
      expect(params.is_a?(Hash)).to eq true
      expect(params[:boardid]).to eq board_id
      expect(params[:action]).to eq action
      expect(params[:sorttype]).to eq 'game'
    end
  end

  describe ".count_by_type" do
    let!(:board1) { create_list :baidu_board, 2, action_type: Baidu::Board::GENERAL_BOARD }
    let!(:board2) { create :baidu_board, action_type: Baidu::Board::RANKLIST_BOARD }
    it "returns count of boards grouped by type" do
      result = Baidu::Board.count_by_type
      expect(result.select{|h| h['action_type'] == Baidu::Board::GENERAL_BOARD }[0]['count']).to eq '2'
      expect(result.select{|h| h['action_type'] == Baidu::Board::RANKLIST_BOARD }[0]['count']).to eq '1'
    end
  end
end
