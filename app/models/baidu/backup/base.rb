class Baidu::Backup::Base
  BACKUP_FOLDER = "backup"

  def self.prepare_folders! path_in_backup_folder
    last_folder = BACKUP_FOLDER
    path_in_backup_folder.split('/').each do |folder|
      last_folder = "#{last_folder}/#{folder}"
      FileUtils.mkdir_p(last_folder) unless File.directory?(last_folder)
    end
    last_folder
  end

  def self.curr_month_and_day_path
    day = Baidu::Helper::DateTime.curr_date
    month_of_day = day.beginning_of_month.to_s
    day_of_day = day.to_s
    "mon#{month_of_day}/day#{day_of_day}"
  end
end
