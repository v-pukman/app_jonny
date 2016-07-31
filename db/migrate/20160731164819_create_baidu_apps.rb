class CreateBaiduApps < ActiveRecord::Migration
  def change
    create_table "baidu_apps", :force => true do |t|
      t.string   "id_str",                     :limit => 191
      t.string   "download_inner",             :limit => 255
      t.integer  "dev_id",                     :limit => 8
      t.string   "dev_name",                   :limit => 255
      t.integer  "dev_score"
      t.integer  "dev_level"
      t.text     "brief"
      t.string   "size",                       :limit => 255
      t.float    "size_mb"
      t.string   "today_str_download",         :limit => 255
      t.float    "platform_version"
      t.string   "sourcename",                 :limit => 255
      t.string   "package",                    :limit => 255
      t.integer  "packageid",                  :limit => 8
      t.integer  "groupid",                    :limit => 8
      t.integer  "docid",                      :limit => 8
      t.string   "versionname",                :limit => 255
      t.text     "manual_brief"
      t.integer  "platform_version_id"
      t.text     "changelog"
      t.string   "catename",                   :limit => 255
      t.integer  "cateid"
      t.string   "app_type",                   :limit => 125
      t.text     "icon"
      t.string   "sname",                      :limit => 191
      t.string   "manual_short_brief",         :limit => 255
      t.date     "updatetime"
      t.integer  "aladdin_flag"
      t.integer  "display_count"
      t.integer  "display_score"
      t.text     "brief_short"
      t.text     "changelog_short"
      t.integer  "total_count",                :limit => 8
      t.integer  "response_count"
      t.integer  "minsdk"
      t.integer  "shareurl"
      t.integer  "packagesize"
      t.string   "all_download_pid",           :limit => 255
      t.integer  "all_download_pid_number",    :limit => 8
      t.integer  "rotate"
      t.integer  "templet"
      t.integer  "yesterday_download_pid"
      t.integer  "today_download_pid"
      t.integer  "now_download"
      t.string   "usenum",                     :limit => 255
      t.integer  "popu_index"
      t.integer  "unable_download"

      t.boolean  "outdated",                                  :default => false
      t.datetime "created_at",                                                   :null => false
      t.datetime "updated_at",                                                   :null => false

      t.integer  "search_position"
      t.integer  "in_board_position"
      t.integer  "baidu_board_id"
      t.integer  "rank_position"
    end

    add_index "baidu_apps", "app_type"
    add_index "baidu_apps", "id_str", :name => "index_baidu_apps_on_id_str", :unique => true
    add_index "baidu_apps", "docid"
    add_index "baidu_apps", "groupid"
    add_index "baidu_apps", "packageid"
    add_index "baidu_apps", "cateid"
    add_index "baidu_apps", "sname"
    add_index "baidu_apps", "created_at"
    add_index "baidu_apps", "outdated"
  end
end
