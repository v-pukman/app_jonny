class CreateBaiduDevelopers < ActiveRecord::Migration
  def change
    create_table :baidu_developers do |t|
      t.integer :origin_id, limit: 8
      t.string :name
      t.integer :score, limit: 8
      t.integer :level

      t.timestamps null: false
    end
    add_index :baidu_developers, :origin_id, unique: true
    add_index :baidu_developers, :name

    add_column :baidu_apps, :developer_id, :integer
    add_index :baidu_apps, :developer_id
  end
end
