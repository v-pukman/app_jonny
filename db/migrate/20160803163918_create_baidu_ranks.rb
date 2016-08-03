class CreateBaiduRanks < ActiveRecord::Migration
  def change
    create_table "baidu_ranks", :force => true do |t|
      t.date     "day"
      t.integer  "rank_number"
      t.integer  "baidu_app_id"
      t.string   "sname"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
      t.string   "rank_type", :limit => 191
      t.string   "board_id", :limit => 191
      t.float    "rise_percent"
    end

    add_index "baidu_ranks", ["baidu_app_id"]
    add_index "baidu_ranks", ["board_id"]
    add_index "baidu_ranks", ["day", "baidu_app_id"]
    add_index "baidu_ranks", ["day"]
    add_index "baidu_ranks", ["rank_number"]
    add_index "baidu_ranks", ["rank_type"]
  end
end
