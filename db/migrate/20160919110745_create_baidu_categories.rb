class CreateBaiduCategories < ActiveRecord::Migration
  def change
    create_table :baidu_categories do |t|
      t.integer :origin_id, limit: 8
      t.string :name

      t.timestamps null: false
    end
    add_index :baidu_categories, :origin_id, unique: true
    add_index :baidu_categories, :name

    add_column :baidu_apps, :category_id, :integer
    add_index :baidu_apps, :category_id
  end
end
