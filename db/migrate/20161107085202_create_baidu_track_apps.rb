class CreateBaiduTrackApps < ActiveRecord::Migration
  def change
    # old baidu_app_days2
    create_table :baidu_track_apps do |t|
      t.integer  :app_id
      t.date     :day

      #reviews
      t.integer  :display_count
      t.integer  :score_count #= display_count
      t.integer  :display_score
      t.float    :avg_rating
      t.integer  :reviews_count

      t.string   :total_count #?
      t.integer  :response_count #?

      #downloads
      t.integer  :yesterday_download_pid, limit: 8
      t.integer  :today_download_pid, limit: 8
      t.integer  :now_download, limit: 8
      t.string   :all_download_pid
      t.string   :usenum #= all_download_pid
      t.string   :today_str_download
      t.string   :str_download
      t.integer  :display_download, limit: 8
      t.string   :all_download

      t.integer  :unable_download

      #popularity
      t.integer  :score
      t.integer  :popularity
      t.integer  :popu_index
      t.boolean  :ishot

      t.integer  :aladdin_flag

      #size
      t.integer  :packagesize, limit: 8

      #t.integer  "search_position"
      #t.integer  "in_board_position"

      #t.integer  "dev_score"
      #t.integer  "dev_level"

      t.timestamps null: false
    end

    add_index :baidu_track_apps, [:app_id, :day], :unique => true
    add_index :baidu_track_apps, :app_id
    add_index :baidu_track_apps, :day
    add_index :baidu_track_apps, [:yesterday_download_pid, :today_download_pid, :now_download], name: 'baidu_track_apps_download_pid_index'
  end
end
