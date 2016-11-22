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

ActiveRecord::Schema.define(version: 20161122082518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baidu_apps", force: :cascade do |t|
    t.string   "id_str"
    t.string   "app_type"
    t.integer  "packageid",              limit: 8
    t.integer  "groupid",                limit: 8
    t.integer  "docid",                  limit: 8
    t.string   "package"
    t.string   "sname"
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
    t.json     "lifeservice"
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
    t.integer  "source_id"
    t.integer  "not_available_count",              default: 0
  end

  add_index "baidu_apps", ["app_type"], name: "index_baidu_apps_on_app_type", using: :btree
  add_index "baidu_apps", ["category_id"], name: "index_baidu_apps_on_category_id", using: :btree
  add_index "baidu_apps", ["created_at"], name: "index_baidu_apps_on_created_at", using: :btree
  add_index "baidu_apps", ["developer_id"], name: "index_baidu_apps_on_developer_id", using: :btree
  add_index "baidu_apps", ["docid"], name: "index_baidu_apps_on_docid", using: :btree
  add_index "baidu_apps", ["groupid"], name: "index_baidu_apps_on_groupid", using: :btree
  add_index "baidu_apps", ["id_str"], name: "index_baidu_apps_on_id_str", unique: true, using: :btree
  add_index "baidu_apps", ["not_available_count"], name: "index_baidu_apps_on_not_available_count", using: :btree
  add_index "baidu_apps", ["packageid"], name: "index_baidu_apps_on_packageid", using: :btree
  add_index "baidu_apps", ["sname"], name: "index_baidu_apps_on_sname", using: :btree
  add_index "baidu_apps", ["source_id"], name: "index_baidu_apps_on_source_id", using: :btree

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

  create_table "baidu_boards", force: :cascade do |t|
    t.string   "name"
    t.string   "origin_id"
    t.string   "action_type"
    t.string   "link"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "sort_type"
  end

  add_index "baidu_boards", ["action_type"], name: "index_baidu_boards_on_action_type", using: :btree
  add_index "baidu_boards", ["link"], name: "index_baidu_boards_on_link", unique: true, using: :btree
  add_index "baidu_boards", ["origin_id"], name: "index_baidu_boards_on_origin_id", using: :btree
  add_index "baidu_boards", ["sort_type"], name: "index_baidu_boards_on_sort_type", using: :btree

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

  create_table "baidu_ranks", force: :cascade do |t|
    t.string   "rank_type"
    t.date     "day"
    t.integer  "rank_number"
    t.integer  "app_id",      limit: 8
    t.jsonb    "info",                  default: {}, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "baidu_ranks", ["app_id"], name: "index_baidu_ranks_on_app_id", using: :btree
  add_index "baidu_ranks", ["day", "app_id"], name: "index_baidu_ranks_on_day_and_app_id", using: :btree
  add_index "baidu_ranks", ["day"], name: "index_baidu_ranks_on_day", using: :btree
  add_index "baidu_ranks", ["info"], name: "index_baidu_ranks_on_info", using: :gin
  add_index "baidu_ranks", ["rank_type"], name: "index_baidu_ranks_on_rank_type", using: :btree

  create_table "baidu_recommend_apps", force: :cascade do |t|
    t.integer  "app_id",             limit: 8
    t.string   "sname"
    t.string   "app_type"
    t.integer  "packageid",          limit: 8
    t.integer  "groupid",            limit: 8
    t.integer  "docid",              limit: 8
    t.integer  "recommend_group_id"
    t.text     "recommend"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "baidu_recommend_apps", ["app_id", "docid", "packageid", "recommend_group_id"], name: "app_docid_group_pack_index", unique: true, using: :btree
  add_index "baidu_recommend_apps", ["app_id"], name: "index_baidu_recommend_apps_on_app_id", using: :btree
  add_index "baidu_recommend_apps", ["docid"], name: "index_baidu_recommend_apps_on_docid", using: :btree
  add_index "baidu_recommend_apps", ["groupid"], name: "index_baidu_recommend_apps_on_groupid", using: :btree
  add_index "baidu_recommend_apps", ["packageid"], name: "index_baidu_recommend_apps_on_packageid", using: :btree
  add_index "baidu_recommend_apps", ["recommend_group_id"], name: "index_baidu_recommend_apps_on_recommend_group_id", using: :btree
  add_index "baidu_recommend_apps", ["sname"], name: "index_baidu_recommend_apps_on_sname", using: :btree

  create_table "baidu_recommend_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "baidu_recommend_groups", ["name"], name: "index_baidu_recommend_groups_on_name", unique: true, using: :btree

  create_table "baidu_sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "baidu_sources", ["name"], name: "index_baidu_sources_on_name", unique: true, using: :btree

  create_table "baidu_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "baidu_tags", ["name"], name: "index_baidu_tags_on_name", unique: true, using: :btree

  create_table "baidu_track_apps", force: :cascade do |t|
    t.integer  "app_id"
    t.date     "day"
    t.integer  "display_count"
    t.integer  "score_count"
    t.integer  "display_score"
    t.float    "avg_rating"
    t.integer  "reviews_count"
    t.string   "total_count"
    t.integer  "response_count"
    t.integer  "yesterday_download_pid", limit: 8
    t.integer  "today_download_pid",     limit: 8
    t.integer  "now_download",           limit: 8
    t.string   "all_download_pid"
    t.string   "usenum"
    t.string   "today_str_download"
    t.string   "str_download"
    t.integer  "display_download",       limit: 8
    t.string   "all_download"
    t.integer  "unable_download"
    t.integer  "score"
    t.integer  "popularity"
    t.integer  "popu_index"
    t.boolean  "ishot"
    t.integer  "aladdin_flag"
    t.integer  "packagesize",            limit: 8
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "baidu_track_apps", ["app_id", "day"], name: "index_baidu_track_apps_on_app_id_and_day", unique: true, using: :btree
  add_index "baidu_track_apps", ["app_id"], name: "index_baidu_track_apps_on_app_id", using: :btree
  add_index "baidu_track_apps", ["day"], name: "index_baidu_track_apps_on_day", using: :btree
  add_index "baidu_track_apps", ["yesterday_download_pid", "today_download_pid", "now_download"], name: "baidu_track_apps_download_pid_index", using: :btree

  create_table "baidu_track_developers", force: :cascade do |t|
    t.integer "developer_id"
    t.date    "day"
    t.integer "score",        limit: 8
    t.integer "level"
  end

  add_index "baidu_track_developers", ["day"], name: "index_baidu_track_developers_on_day", using: :btree
  add_index "baidu_track_developers", ["developer_id", "day"], name: "index_baidu_track_developers_on_developer_id_and_day", unique: true, using: :btree
  add_index "baidu_track_developers", ["developer_id"], name: "index_baidu_track_developers_on_developer_id", using: :btree

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

  create_table "logs", force: :cascade do |t|
    t.string   "level"
    t.string   "area"
    t.string   "class_name"
    t.string   "method_name"
    t.text     "message"
    t.json     "context"
    t.text     "backtrace"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "logs", ["area"], name: "index_logs_on_area", using: :btree
  add_index "logs", ["class_name"], name: "index_logs_on_class_name", using: :btree
  add_index "logs", ["level"], name: "index_logs_on_level", using: :btree
  add_index "logs", ["method_name"], name: "index_logs_on_method_name", using: :btree

end
