require 'rails_helper'

RSpec.describe Baidu::Backup::App do
  let(:backup_folder) { Baidu::Backup::Base::BACKUP_FOLDER }
  let(:service) { Baidu::Backup::App }

  describe ".generate_file_path!" do
    it "returns file path with app_id" do
      result = service.generate_file_path! 15
      expect(result).to include "/15_full_info.json"
    end
  end

  describe ".backup_full_info" do
    let(:app_id) { Time.now.to_i }
    let(:file_path) { service.generate_file_path!(app_id) }
    let(:data_hash) do
      { docid: 1, sname: "rock-n-roll" }
    end
    it "creates a file" do
      service.backup_full_info app_id, data_hash
      expect(File.exist?(file_path)).to eq true
    end
    it "saves hash to file" do
      service.backup_full_info app_id, data_hash
      result = JSON.parse File.read(file_path)
      expect(result['docid']).to eq data_hash[:docid]
      expect(result['sname']).to eq data_hash[:sname]
    end
  end
end
