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

ActiveRecord::Schema.define(version: 20160731164819) do

  create_table "baidu_apps", force: :cascade do |t|
    t.string   "id_str",                  limit: 191
    t.string   "download_inner",          limit: 255
    t.integer  "dev_id",                  limit: 8
    t.string   "dev_name",                limit: 255
    t.integer  "dev_score",               limit: 4
    t.integer  "dev_level",               limit: 4
    t.text     "brief",                   limit: 65535
    t.string   "size",                    limit: 255
    t.float    "size_mb",                 limit: 24
    t.string   "today_str_download",      limit: 255
    t.float    "platform_version",        limit: 24
    t.string   "sourcename",              limit: 255
    t.string   "package",                 limit: 255
    t.integer  "packageid",               limit: 8
    t.integer  "groupid",                 limit: 8
    t.integer  "docid",                   limit: 8
    t.string   "versionname",             limit: 255
    t.text     "manual_brief",            limit: 65535
    t.integer  "platform_version_id",     limit: 4
    t.text     "changelog",               limit: 65535
    t.string   "catename",                limit: 255
    t.integer  "cateid",                  limit: 4
    t.string   "app_type",                limit: 125
    t.text     "icon",                    limit: 65535
    t.string   "sname",                   limit: 191
    t.string   "manual_short_brief",      limit: 255
    t.date     "updatetime"
    t.integer  "aladdin_flag",            limit: 4
    t.integer  "display_count",           limit: 4
    t.integer  "display_score",           limit: 4
    t.text     "brief_short",             limit: 65535
    t.text     "changelog_short",         limit: 65535
    t.integer  "total_count",             limit: 8
    t.integer  "response_count",          limit: 4
    t.integer  "minsdk",                  limit: 4
    t.integer  "shareurl",                limit: 4
    t.integer  "packagesize",             limit: 4
    t.string   "all_download_pid",        limit: 255
    t.integer  "all_download_pid_number", limit: 8
    t.integer  "rotate",                  limit: 4
    t.integer  "templet",                 limit: 4
    t.integer  "yesterday_download_pid",  limit: 4
    t.integer  "today_download_pid",      limit: 4
    t.integer  "now_download",            limit: 4
    t.string   "usenum",                  limit: 255
    t.integer  "popu_index",              limit: 4
    t.integer  "unable_download",         limit: 4
    t.boolean  "outdated",                              default: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "search_position",         limit: 4
    t.integer  "in_board_position",       limit: 4
    t.integer  "baidu_board_id",          limit: 4
    t.integer  "rank_position",           limit: 4
  end

  add_index "baidu_apps", ["app_type"], name: "index_baidu_apps_on_app_type", using: :btree
  add_index "baidu_apps", ["cateid"], name: "index_baidu_apps_on_cateid", using: :btree
  add_index "baidu_apps", ["created_at"], name: "index_baidu_apps_on_created_at", using: :btree
  add_index "baidu_apps", ["docid"], name: "index_baidu_apps_on_docid", using: :btree
  add_index "baidu_apps", ["groupid"], name: "index_baidu_apps_on_groupid", using: :btree
  add_index "baidu_apps", ["id_str"], name: "index_baidu_apps_on_id_str", unique: true, using: :btree
  add_index "baidu_apps", ["outdated"], name: "index_baidu_apps_on_outdated", using: :btree
  add_index "baidu_apps", ["packageid"], name: "index_baidu_apps_on_packageid", using: :btree
  add_index "baidu_apps", ["sname"], name: "index_baidu_apps_on_sname", using: :btree

end
