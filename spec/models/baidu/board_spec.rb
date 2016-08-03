require 'rails_helper'

RSpec.describe Baidu::Board, type: :model do
  it "has factory" do
    board = create :baidu_board
    expect(board.persisted?).to eq true
  end
end
