# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160803164438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baidu_apps", force: :cascade do |t|
    t.string   "id_str",                  limit: 255
    t.string   "download_inner",          limit: 255
    t.integer  "dev_id",                  limit: 8
    t.string   "dev_name",                limit: 255
    t.integer  "dev_score"
    t.integer  "dev_level"
    t.text     "brief"
    t.string   "size",                    limit: 255
    t.float    "size_mb"
    t.string   "today_str_download",      limit: 255
    t.float    "platform_version"
    t.string   "sourcename",              limit: 255
    t.string   "package",                 limit: 255
    t.integer  "packageid",               limit: 8
    t.integer  "groupid",                 limit: 8
    t.integer  "docid",                   limit: 8
    t.string   "versionname",             limit: 255
    t.text     "manual_brief"
    t.integer  "platform_version_id"
    t.text     "changelog"
    t.string   "catename",                limit: 255
    t.integer  "cateid"
    t.string   "app_type",                limit: 125
    t.text     "icon"
    t.string   "sname",                   limit: 255
    t.string   "manual_short_brief",      limit: 255
    t.date     "updatetime"
    t.integer  "aladdin_flag"
    t.integer  "display_count"
    t.integer  "display_score"
    t.text     "brief_short"
    t.text     "changelog_short"
    t.integer  "total_count",             limit: 8
    t.integer  "response_count"
    t.integer  "minsdk"
    t.integer  "shareurl"
    t.integer  "packagesize"
    t.string   "all_download_pid",        limit: 255
    t.integer  "all_download_pid_number", limit: 8
    t.integer  "rotate"
    t.integer  "templet"
    t.integer  "yesterday_download_pid"
    t.integer  "today_download_pid"
    t.integer  "now_download"
    t.string   "usenum",                  limit: 255
    t.integer  "popu_index"
    t.integer  "unable_download"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "baidu_apps", ["app_type"], name: "index_baidu_apps_on_app_type", using: :btree
  add_index "baidu_apps", ["cateid"], name: "index_baidu_apps_on_cateid", using: :btree
  add_index "baidu_apps", ["created_at"], name: "index_baidu_apps_on_created_at", using: :btree
  add_index "baidu_apps", ["docid"], name: "index_baidu_apps_on_docid", using: :btree
  add_index "baidu_apps", ["groupid"], name: "index_baidu_apps_on_groupid", using: :btree
  add_index "baidu_apps", ["id_str"], name: "index_baidu_apps_on_id_str", unique: true, using: :btree
  add_index "baidu_apps", ["packageid"], name: "index_baidu_apps_on_packageid", using: :btree
  add_index "baidu_apps", ["sname"], name: "index_baidu_apps_on_sname", using: :btree

  create_table "baidu_boards", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "board_id",   limit: 255
    t.string   "link",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "baidu_boards", ["board_id"], name: "index_baidu_boards_on_board_id", using: :btree
  add_index "baidu_boards", ["link"], name: "index_baidu_boards_on_link", using: :btree
  add_index "baidu_boards", ["name"], name: "index_baidu_boards_on_name", using: :btree

  create_table "baidu_comments", force: :cascade do |t|
    t.string   "id_str",               limit: 255
    t.integer  "baidu_app_id",         limit: 8
    t.integer  "thread_id",            limit: 8
    t.integer  "reply_id",             limit: 8
    t.integer  "parent_id",            limit: 8
    t.integer  "reply_count"
    t.integer  "score"
    t.integer  "favor"
    t.integer  "is_top"
    t.integer  "like_count"
    t.integer  "dislike_count"
    t.integer  "display"
    t.datetime "create_time"
    t.integer  "user_id",              limit: 8
    t.string   "user_name"
    t.string   "user_ip"
    t.string   "area"
    t.integer  "reserved1"
    t.integer  "reserved2"
    t.datetime "mdatetime"
    t.string   "title"
    t.text     "content"
    t.string   "receiver_name"
    t.string   "reserved3_version"
    t.string   "reserved3_machine"
    t.string   "reserved3_fromsite"
    t.string   "reserved3_installed"
    t.text     "usericon"
    t.integer  "reply_total_count"
    t.integer  "reply_response_count"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "baidu_comments", ["baidu_app_id"], name: "index_baidu_comments_on_baidu_app_id", using: :btree
  add_index "baidu_comments", ["id_str"], name: "index_baidu_comments_on_id_str", using: :btree
  add_index "baidu_comments", ["parent_id"], name: "index_baidu_comments_on_parent_id", using: :btree
  add_index "baidu_comments", ["reply_id"], name: "index_baidu_comments_on_reply_id", using: :btree
  add_index "baidu_comments", ["thread_id"], name: "index_baidu_comments_on_thread_id", using: :btree
  add_index "baidu_comments", ["user_id"], name: "index_baidu_comments_on_user_id", using: :btree

  create_table "baidu_days", force: :cascade do |t|
    t.float    "avg_rating"
    t.integer  "reviews_count"
    t.float    "yesterday_download_pid"
    t.float    "today_download_pid"
    t.integer  "now_download"
    t.string   "usenum",                  limit: 255
    t.string   "all_download_pid",        limit: 255
    t.string   "today_str_download",      limit: 255
    t.integer  "popularity"
    t.integer  "popu_index"
    t.integer  "display_count"
    t.integer  "display_score"
    t.string   "total_count",             limit: 255
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
    t.integer  "all_download_pid_number", limit: 8
    t.integer  "dev_score"
    t.integer  "dev_level"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "baidu_days", ["baidu_app_id", "day"], name: "index_baidu_days_on_baidu_app_id_and_day", unique: true, using: :btree
  add_index "baidu_days", ["baidu_app_id"], name: "index_baidu_days_on_baidu_app_id", using: :btree
  add_index "baidu_days", ["day"], name: "index_baidu_days_on_day", using: :btree
  add_index "baidu_days", ["yesterday_download_pid", "today_download_pid", "now_download"], name: "baidu_days_pid_index", using: :btree

  create_table "baidu_ranks", force: :cascade do |t|
    t.date     "day"
    t.integer  "rank_number"
    t.integer  "baidu_app_id"
    t.string   "sname"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "rank_type",    limit: 255
    t.string   "board_id",     limit: 255
    t.float    "rise_percent"
  end

  add_index "baidu_ranks", ["baidu_app_id"], name: "index_baidu_ranks_on_baidu_app_id", using: :btree
  add_index "baidu_ranks", ["board_id"], name: "index_baidu_ranks_on_board_id", using: :btree
  add_index "baidu_ranks", ["day", "baidu_app_id"], name: "index_baidu_ranks_on_day_and_baidu_app_id", using: :btree
  add_index "baidu_ranks", ["day"], name: "index_baidu_ranks_on_day", using: :btree
  add_index "baidu_ranks", ["rank_number"], name: "index_baidu_ranks_on_rank_number", using: :btree
  add_index "baidu_ranks", ["rank_type"], name: "index_baidu_ranks_on_rank_type", using: :btree

end
