class CreateBaiduVersions < ActiveRecord::Migration
  def change
    create_table :baidu_versions do |t|
      t.integer :app_id, limit: 8

      t.string :id_str
      t.string :name
      t.integer :code, limit: 8
      t.integer :packageid, limit: 8
      t.integer :groupid, limit: 8
      t.integer :docid, limit: 8
      t.string :sname
      t.string :size
      t.date :updatetime
      t.string :sourcename
      t.string :app_type
      t.string :all_download_pid
      t.string :str_download
      t.integer :display_score
      t.string :all_download

      t.timestamps null: false
    end

    add_index :baidu_versions, :app_id
    add_index :baidu_versions, [:app_id, :id_str], unique: true
    add_index :baidu_versions, :updatetime
  end
end
