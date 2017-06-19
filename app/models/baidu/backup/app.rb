class Baidu::Backup::App < Baidu::Backup::Base
  def self.generate_file_path! app_id
    backup_folder = prepare_folders! "baidu/apps/#{curr_month_and_day_path}"
    "#{backup_folder}/#{app_id}_full_info.json"
  end

  def self.backup_full_info app_id, full_info_hash
    return #SKIP IT FOR NOW!!!
    file_path = generate_file_path! app_id

    if !full_info_hash.blank? && !File.exist?(file_path)
      File.open(file_path, "w+") do |f|
        f.write(JSON.dump(full_info_hash))
      end
    end
  rescue StandardError => e
    Log.error Log::BAIDU_AREA, self.class, :backup_full_info, e, { app_id: app_id, full_info_hash: full_info_hash }
  end
end
