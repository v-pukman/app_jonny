class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :level
      t.string :area
      t.string :class_name
      t.string :method_name
      t.text :message
      t.json :context
      t.text :backtrace

      t.timestamps null: false
    end
    add_index :logs, :level
    add_index :logs, :area
    add_index :logs, :class_name
    add_index :logs, :method_name
  end
end
