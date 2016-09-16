class CreateBaiduComments < ActiveRecord::Migration
  def change
    create_table "baidu_comments" do |t|
      t.string   "id_str"
      t.integer  "baidu_app_id",         :limit => 8
      t.integer  "thread_id",            :limit => 8
      t.integer  "reply_id",             :limit => 8
      t.integer  "parent_id",            :limit => 8
      t.integer  "reply_count"
      t.integer  "score"
      t.integer  "favor"
      t.integer  "is_top"
      t.integer  "like_count"
      t.integer  "dislike_count"
      t.integer  "display"
      t.datetime "create_time"
      t.integer  "user_id",              :limit => 8
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
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
    end

    add_index "baidu_comments", ["baidu_app_id"]
    add_index "baidu_comments", ["id_str"]
    add_index "baidu_comments", ["parent_id"]
    add_index "baidu_comments", ["reply_id"]
    add_index "baidu_comments", ["thread_id"]
    add_index "baidu_comments", ["user_id"]

  end
end
