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

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baidu_apps", force: :cascade do |t|
    t.string   "id_str"
    t.string   "packageid",              limit: 8
    t.string   "groupid",                limit: 8
    t.string   "docid",                  limit: 8
    t.string   "package"
    t.string   "sname"
    t.string   "app_type"
    t.text     "icon"
    t.string   "iconhdpi"
    t.integer  "today_download_pid",     limit: 8
    t.string   "today_str_download"
    t.string   "str_download"
    t.string   "all_download_pid"
    t.integer  "display_download",       limit: 8
    t.integer  "yesterday_download_pid", limit: 8
    t.integer  "now_download",           limit: 8
    t.string   "usenum"
    t.string   "all_download"
    t.integer  "popu_index"
    t.integer  "display_score"
    t.integer  "display_count"
    t.integer  "score_count",            limit: 8
    t.integer  "score"
    t.integer  "popularity"
    t.boolean  "ishot"
    t.integer  "packagesize"
    t.string   "size"
    t.string   "download_inner"
    t.string   "lang"
    t.string   "signmd5"
    t.json     "security_display"
    t.string   "security"
    t.text     "brief"
    t.string   "platform_version"
    t.string   "sourcename"
    t.string   "fee_display"
    t.integer  "aladdin_flag"
    t.text     "manual_brief"
    t.string   "platform_version_id"
    t.text     "changelog"
    t.string   "md5"
    t.text     "manual_short_brief"
    t.date     "updatetime"
    t.string   "download_url"
    t.json     "ad_display"
    t.integer  "support_chip"
    t.integer  "rotate"
    t.integer  "gov_whitelist"
    t.json     "comment_tag_display"
    t.integer  "templet"
    t.integer  "online_flag"
    t.json     "tag_concept_rp"
    t.integer  "mtc_status"
    t.string   "lifeservice"
    t.string   "inner_info"
    t.string   "coupon"
    t.text     "screenshots",                      default: [], array: true
    t.integer  "overtime"
    t.json     "topic"
    t.integer  "self_score"
    t.text     "brief_short"
    t.text     "changelog_short"
    t.text     "screenshots_large",                default: [], array: true
    t.integer  "ad_docid",               limit: 8
    t.string   "ad_words"
    t.text     "permission_type",                  default: [], array: true
    t.text     "permission_guide",                 default: [], array: true
    t.integer  "fav_count"
    t.integer  "is_fold"
    t.string   "single_intro"
    t.integer  "supportpad"
    t.string   "total_count",            limit: 8
    t.string   "response_count"
    t.string   "minsdk"
    t.string   "shareurl"
    t.string   "award_info"
    t.integer  "unable_download"
    t.boolean  "hastieba"
    t.integer  "feedback_appchannel"
    t.string   "detail_background"
    t.string   "app_gift_title"
    t.string   "official_icon_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "baidu_apps", ["app_type"], name: "index_baidu_apps_on_app_type", using: :btree
  add_index "baidu_apps", ["created_at"], name: "index_baidu_apps_on_created_at", using: :btree
  add_index "baidu_apps", ["docid"], name: "index_baidu_apps_on_docid", using: :btree
  add_index "baidu_apps", ["groupid"], name: "index_baidu_apps_on_groupid", using: :btree
  add_index "baidu_apps", ["id_str"], name: "index_baidu_apps_on_id_str", unique: true, using: :btree
  add_index "baidu_apps", ["packageid"], name: "index_baidu_apps_on_packageid", using: :btree
  add_index "baidu_apps", ["sname"], name: "index_baidu_apps_on_sname", using: :btree

end
