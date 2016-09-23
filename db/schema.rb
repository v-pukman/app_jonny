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

ActiveRecord::Schema.define(version: 20160919150133) do

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
    t.integer  "developer_id"
    t.integer  "category_id"
  end

  add_index "baidu_apps", ["app_type"], name: "index_baidu_apps_on_app_type", using: :btree
  add_index "baidu_apps", ["category_id"], name: "index_baidu_apps_on_category_id", using: :btree
  add_index "baidu_apps", ["created_at"], name: "index_baidu_apps_on_created_at", using: :btree
  add_index "baidu_apps", ["developer_id"], name: "index_baidu_apps_on_developer_id", using: :btree
  add_index "baidu_apps", ["docid"], name: "index_baidu_apps_on_docid", using: :btree
  add_index "baidu_apps", ["groupid"], name: "index_baidu_apps_on_groupid", using: :btree
  add_index "baidu_apps", ["id_str"], name: "index_baidu_apps_on_id_str", unique: true, using: :btree
  add_index "baidu_apps", ["packageid"], name: "index_baidu_apps_on_packageid", using: :btree
  add_index "baidu_apps", ["sname"], name: "index_baidu_apps_on_sname", using: :btree

  create_table "baidu_apps_display_tags", force: :cascade do |t|
    t.integer "display_tag_id"
    t.integer "app_id"
  end

  add_index "baidu_apps_display_tags", ["app_id"], name: "index_baidu_apps_display_tags_on_app_id", using: :btree
  add_index "baidu_apps_display_tags", ["display_tag_id"], name: "index_baidu_apps_display_tags_on_display_tag_id", using: :btree

  create_table "baidu_apps_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "app_id"
  end

  add_index "baidu_apps_tags", ["app_id"], name: "index_baidu_apps_tags_on_app_id", using: :btree
  add_index "baidu_apps_tags", ["tag_id"], name: "index_baidu_apps_tags_on_tag_id", using: :btree

  create_table "baidu_categories", force: :cascade do |t|
    t.integer  "origin_id",  limit: 8
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "baidu_categories", ["name"], name: "index_baidu_categories_on_name", using: :btree
  add_index "baidu_categories", ["origin_id"], name: "index_baidu_categories_on_origin_id", unique: true, using: :btree

  create_table "baidu_developers", force: :cascade do |t|
    t.integer  "origin_id",  limit: 8
    t.string   "name"
    t.integer  "score",      limit: 8
    t.integer  "level"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "baidu_developers", ["name"], name: "index_baidu_developers_on_name", using: :btree
  add_index "baidu_developers", ["origin_id"], name: "index_baidu_developers_on_origin_id", unique: true, using: :btree

  create_table "baidu_display_tags", force: :cascade do |t|
    t.string   "name"
    t.string   "content_json", default: ""
    t.string   "content",      default: ""
    t.string   "icon"
    t.string   "flagicon"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "baidu_display_tags", ["name", "content", "content_json"], name: "index_baidu_display_tags_on_name_and_content_and_content_json", unique: true, using: :btree
  add_index "baidu_display_tags", ["name"], name: "index_baidu_display_tags_on_name", using: :btree

  create_table "baidu_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "baidu_tags", ["name"], name: "index_baidu_tags_on_name", unique: true, using: :btree

  create_table "baidu_versions", force: :cascade do |t|
    t.integer  "app_id",           limit: 8
    t.string   "id_str"
    t.string   "name"
    t.integer  "code",             limit: 8
    t.integer  "packageid",        limit: 8
    t.integer  "groupid",          limit: 8
    t.integer  "docid",            limit: 8
    t.string   "sname"
    t.string   "size"
    t.date     "updatetime"
    t.string   "sourcename"
    t.string   "app_type"
    t.string   "all_download_pid"
    t.string   "str_download"
    t.integer  "display_score"
    t.string   "all_download"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "baidu_versions", ["app_id", "id_str"], name: "index_baidu_versions_on_app_id_and_id_str", unique: true, using: :btree
  add_index "baidu_versions", ["app_id"], name: "index_baidu_versions_on_app_id", using: :btree
  add_index "baidu_versions", ["updatetime"], name: "index_baidu_versions_on_updatetime", using: :btree

  create_table "baidu_videos", force: :cascade do |t|
    t.integer  "app_id",      limit: 8
    t.integer  "origin_id",   limit: 8
    t.integer  "packageid",   limit: 8
    t.string   "title"
    t.string   "source"
    t.string   "videourl"
    t.string   "image"
    t.string   "playcount"
    t.integer  "orientation"
    t.string   "duration"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "baidu_videos", ["app_id"], name: "index_baidu_videos_on_app_id", unique: true, using: :btree
  add_index "baidu_videos", ["origin_id"], name: "index_baidu_videos_on_origin_id", using: :btree

end
