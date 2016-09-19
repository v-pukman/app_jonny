class CreateBaiduDisplayTags < ActiveRecord::Migration
  def change
    create_table :baidu_display_tags do |t|
      t.string :name
      t.string :content_json, default: ""
      t.string :content, default: ""
      t.string :icon
      t.string :flagicon

      t.timestamps null: false
    end
    add_index :baidu_display_tags, :name
    add_index :baidu_display_tags, [:name, :content, :content_json], unique: true

    create_table :baidu_apps_display_tags do |t|
      t.integer :display_tag_id
      t.integer :app_id
    end
    add_index :baidu_apps_display_tags, :display_tag_id
    add_index :baidu_apps_display_tags, :app_id
  end
end
