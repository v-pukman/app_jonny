class CreateBaiduTrackDevelopers < ActiveRecord::Migration
  def change
    create_table :baidu_track_developers do |t|
      t.integer  :developer_id
      t.date     :day

      t.integer :score, limit: 8
      t.integer :level
    end

    add_index :baidu_track_developers, :developer_id
    add_index :baidu_track_developers, :day
    add_index :baidu_track_developers, [:developer_id, :day], unique: true
  end
end
