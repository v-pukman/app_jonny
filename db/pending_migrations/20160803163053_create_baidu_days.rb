class CreateBaiduDays < ActiveRecord::Migration
  def change
    # old baidu_app_days2
    create_table "baidu_days" do |t|
      t.float    "avg_rating"
      t.integer  "reviews_count"
      t.float    "yesterday_download_pid"
      t.float    "today_download_pid"
      t.integer  "now_download"
      t.string   "usenum"
      t.string   "all_download_pid"
      t.string   "today_str_download"
      t.integer  "popularity"
      t.integer  "popu_index"
      t.integer  "display_count"
      t.integer  "display_score"
      t.string   "total_count"
      t.integer  "response_count"
      t.integer  "display_download"
      t.boolean  "ishot"
      t.integer  "score_count"
      t.integer  "score"
      t.integer  "aladdin_flag"
      t.integer  "baidu_app_id"
      t.date     "day"
      t.integer  "search_position"
      t.integer  "in_board_position"
      t.integer  "all_download_pid_number", :limit => 8
      t.integer  "dev_score"
      t.integer  "dev_level"

      t.datetime "created_at",                                    :null => false
      t.datetime "updated_at",                                    :null => false
    end

    add_index "baidu_days", ["baidu_app_id", "day"], :unique => true
    add_index "baidu_days", ["baidu_app_id"]
    add_index "baidu_days", ["day"]
    add_index "baidu_days", ["yesterday_download_pid", "today_download_pid", "now_download"], name: "baidu_days_pid_index"
  end
end
