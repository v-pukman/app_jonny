class AddNotAvailableCountToBaiduApps < ActiveRecord::Migration
  def change
    add_column :baidu_apps, :not_available_count, :integer, default: 0
    add_index :baidu_apps, :not_available_count
  end
end
