class CreateBaiduVideos < ActiveRecord::Migration
  def change
    create_table :baidu_videos do |t|
      t.integer :app_id, limit: 8
      t.integer :origin_id, limit: 8
      t.integer :packageid, limit: 8

      t.string :title
      t.string :source
      t.string :videourl
      t.string :image

      t.string :playcount
      t.integer :orientation
      t.string :duration

      t.timestamps null: false
    end
    add_index :baidu_videos, :app_id, unique: true
    add_index :baidu_videos, :origin_id
  end
end
