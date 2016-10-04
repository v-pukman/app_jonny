class CreateBaiduApps < ActiveRecord::Migration
  def change
    create_table :baidu_apps do |t|
      t.string :id_str

      t.string :app_type
      t.integer :packageid, limit: 8
      t.integer :groupid, limit: 8
      t.integer :docid, limit: 8

      t.string :package
      t.string :sname
      #t.string :source
      t.text :icon
      t.string :iconhdpi

      t.integer :today_download_pid, limit: 8
      t.string :today_str_download
      t.string :str_download
      t.string :all_download_pid
      t.integer :display_download, limit: 8
      t.integer :yesterday_download_pid, limit: 8
      t.integer :now_download, limit: 8
      t.string :usenum
      t.string :all_download

      t.integer :popu_index
      t.integer :display_score
      t.integer :display_count
      t.integer :score_count, limit: 8
      t.integer :score
      t.integer :popularity
      t.boolean :ishot

      t.integer :packagesize
      t.string :size

      t.string :download_inner
      #t.string :versioncode
      t.string :lang
      t.string :signmd5

      t.json :security_display
      t.string :security
      #t.integer :cateid
      t.text :brief


      t.string :platform_version
      t.string :fee_display
      t.integer :aladdin_flag

      #t.string :versionname
      t.text :manual_brief
      t.string :platform_version_id
      t.text :changelog
      #t.string :catename

      t.string :md5
      t.text :manual_short_brief
      t.date :updatetime
      t.string :download_url
      t.json :ad_display
      t.integer :support_chip
      t.integer :rotate
      t.integer :gov_whitelist
      t.json :comment_tag_display
      t.integer :templet
      t.integer :online_flag

      t.json :tag_concept_rp
      t.integer :mtc_status
      t.string :lifeservice
      #t.string :video_videourl
      #t.string :video_playcount
      #t.string :video_image
      t.string :inner_info
      #t.string :video_orientation
      #t.string :video_duration
      #t.string :video_source
      #t.string :video_id
      #t.string :video_title
      t.string :coupon
      #t.string :video_packageid
      t.text :screenshots, array: true, default: []
      t.integer :overtime
      t.json :topic

      t.integer :self_score
      t.text :brief_short
      t.text :changelog_short
      t.text :screenshots_large, array: true, default: []
      t.integer :ad_docid, limit: 8
      t.string :ad_words
      t.text :permission_type, array: true, default: []
      t.text :permission_guide, array: true, default: []
      t.integer :fav_count
      t.integer :is_fold
      t.string :single_intro
      t.integer :supportpad

      t.string :total_count, limit: 8
      t.string :response_count
      #t.string :self_send
      t.string :minsdk

      t.string :shareurl


      #t.json :tag_display
      #t.text :apptags
      t.string :award_info
      t.integer :unable_download
      t.boolean :hastieba
      t.integer :feedback_appchannel

      # from preview:
      #  :detail_background
      #  :app_gift_title
      #  :score_count, limit: 8
      #  :all_download
      #  :score
      #  :popularity
      #  :ishot
      #  :official_icon_url

      t.string :detail_background
      t.string :app_gift_title
      t.string :official_icon_url

      t.timestamps
    end

    add_index :baidu_apps, :id_str, name: 'index_baidu_apps_on_id_str', unique: true
    add_index :baidu_apps, :app_type
    add_index :baidu_apps, :docid
    add_index :baidu_apps, :groupid
    add_index :baidu_apps, :packageid
    add_index :baidu_apps, :sname
    add_index :baidu_apps, :created_at
  end
end
