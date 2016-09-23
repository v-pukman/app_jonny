class CreateBaiduRecommendApps < ActiveRecord::Migration
  def change
    create_table :baidu_recommend_apps do |t|
      t.integer :app_id, limit: 8
      t.string :sname

      t.string :app_type
      t.integer :packageid, limit: 8
      t.integer :groupid, limit: 8
      t.integer :docid, limit: 8

      t.integer :recommend_group_id
      t.text :recommend

      t.timestamps null: false
    end
    add_index :baidu_recommend_apps, :app_id
    add_index :baidu_recommend_apps, :sname
    add_index :baidu_recommend_apps, [:app_id, :docid, :packageid, :recommend_group_id], unique: true, name: 'app_docid_group_pack_index'
    add_index :baidu_recommend_apps, :recommend_group_id
    add_index :baidu_recommend_apps, :packageid
    add_index :baidu_recommend_apps, :groupid
    add_index :baidu_recommend_apps, :docid
  end
end
