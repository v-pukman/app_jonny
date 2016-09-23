class CreateBaiduRecommendGroups < ActiveRecord::Migration
  def change
    create_table :baidu_recommend_groups do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :baidu_recommend_groups, :name, unique: true
  end
end
