class AddSortTypeToBaiduBoards < ActiveRecord::Migration
  def change
    add_column :baidu_boards, :sort_type, :string
    add_index :baidu_boards, :sort_type
  end
end
