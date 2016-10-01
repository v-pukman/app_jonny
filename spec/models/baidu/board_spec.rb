require 'rails_helper'

RSpec.describe Baidu::Board, type: :model do
  let(:board) { create :baidu_board }
  it "has a factory" do
    expect(board.persisted?).to eq true
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
    let(:board_id) { "board_100_500" }
    let(:action) { "megaboard" }
    let(:link) { "appsrv?boardid=#{board_id}&action=#{action}" }
    let(:link_var2) { "appsrv?board=#{board_id}&action=#{action}" }

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
  end
end
