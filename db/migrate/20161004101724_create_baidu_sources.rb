class CreateBaiduSources < ActiveRecord::Migration
  def change
    create_table :baidu_sources do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :baidu_sources, :name, unique: true

    add_column :baidu_apps, :source_id, :integer
    add_index :baidu_apps, :source_id
  end
end
