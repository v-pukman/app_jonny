class CreateBaiduRanks < ActiveRecord::Migration
  def change
    create_table :baidu_ranks do |t|
      t.string :rank_type
      t.date :day
      t.integer :rank_number
      t.integer :app_id, limit: 8
      t.jsonb :info, null: false, default: '{}'

      t.timestamps null: false
    end

    add_index :baidu_ranks, :rank_type
    add_index :baidu_ranks, :day
    add_index :baidu_ranks, :app_id

    add_index :baidu_ranks, [:rank_type, :day, :app_id], unique: true
    add_index :baidu_ranks, [:day, :app_id]

    add_index :baidu_ranks, :info, using: :gin
  end
end
