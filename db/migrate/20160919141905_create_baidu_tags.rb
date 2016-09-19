class CreateBaiduTags < ActiveRecord::Migration
  def change
    create_table :baidu_tags do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :baidu_tags, :name, unique: true

    create_table :baidu_apps_tags do |t|
      t.integer :tag_id
      t.integer :app_id
    end
    add_index :baidu_apps_tags, :tag_id
    add_index :baidu_apps_tags, :app_id
  end
end
