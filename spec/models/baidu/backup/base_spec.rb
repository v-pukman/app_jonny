require 'rails_helper'

RSpec.describe Baidu::Backup::Base do
  let(:backup_folder) { Baidu::Backup::Base::BACKUP_FOLDER }
  let(:service) { Baidu::Backup::Base }
  describe ".prepare_folders!" do
    it "ceates folders from relative path" do
      service.prepare_folders! "rspec/apps/days"
      expect(File.exist?("#{backup_folder}/rspec")).to eq true
      expect(File.exist?("#{backup_folder}/rspec/apps")).to eq true
      expect(File.exist?("#{backup_folder}/rspec/apps/days")).to eq true
    end
    it "returns full backup path" do
      result = service.prepare_folders! "rspec/apps/days"
      expect(result).to eq "#{backup_folder}/rspec/apps/days"
    end
  end
  describe ".curr_month_and_day_path" do
    it "returns mon and day in path" do
      result = service.curr_month_and_day_path
      expect(result).to_not eq nil
      expect(result.split('/')[0]).to include "#{Baidu::Helper::DateTime.curr_date.beginning_of_month}"
      expect(result.split('/')[1]).to include "#{Baidu::Helper::DateTime.curr_date}"
    end
  end
end
