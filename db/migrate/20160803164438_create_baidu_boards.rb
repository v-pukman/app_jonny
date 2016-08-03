class CreateBaiduBoards < ActiveRecord::Migration
  def change
    # old baidu_game_boards
    create_table "baidu_boards", :force => true do |t|
      t.string   "name", :limit => 191
      t.string   "board_id", :limit => 191
      t.string   "link", :limit => 191
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "baidu_boards", ["board_id"]
    add_index "baidu_boards", ["link"]
    add_index "baidu_boards", ["name"]
  end
end
