class CreateBaiduBoards < ActiveRecord::Migration
  def change
    # old baidu_game_boards
    create_table "baidu_boards" do |t|
      t.string   "name"
      t.string   "board_id"
      t.string   "link"

      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "baidu_boards", ["board_id"]
    add_index "baidu_boards", ["link"]
    add_index "baidu_boards", ["name"]
  end
end
