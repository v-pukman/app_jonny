class CreateBaiduBoards < ActiveRecord::Migration
  def change
    create_table :baidu_boards do |t|
      t.string :name
      t.string :origin_id
      t.string :action_type
      t.string :link

      t.timestamps null: false
    end
    add_index :baidu_boards, :link, unique: true
    add_index :baidu_boards, :origin_id
    add_index :baidu_boards, :action_type
  end
end
