require 'rails_helper'

RSpec.describe Baidu::Analytic::App do
  let(:service) { Baidu::Analytic::App }
  describe ".not_tracked" do
    before do
      allow(Baidu::Service::Track::App).to receive(:save_track).and_return(nil)
    end
    let(:day) { Date.yesterday }
    let!(:app1) { create :baidu_app }
    let!(:app2) { create :baidu_app }
    let!(:track1) { create :baidu_track_app, app: app1, day: day }
    let!(:track2) { create :baidu_track_app, app: app2, day: day }
    it "select apps with no tracks" do
      track1.destroy
      result = service.not_tracked day
      expect(result.map{|row| row['id'].to_i }).to eq [app1.id]
    end
    it "uses day for select" do
      track2.update_attributes day: Date.today
      result = service.not_tracked day
      expect(result.map{|row| row['id'].to_i }).to eq [app2.id]
    end
    it "uses not_available_count" do
      app1.update_attributes not_available_count: Baidu::App::NOT_AVAILABLE_MAX - 1
      app2.update_attributes not_available_count: Baidu::App::NOT_AVAILABLE_MAX + 1
      app1.tracks.destroy_all
      app2.tracks.destroy_all
      result = service.not_tracked(day).map{|row| row['id'].to_i }
      expect(result).to include app1.id
      expect(result).to_not include app2.id
    end
  end
  describe ".not_tracked_ids" do
    it "returns list of integer ids" do
      allow(service).to receive(:not_tracked).and_return([{id: 4}, {id: 10}].as_json)
      expect(service.not_tracked_ids('2016-01-01')).to eq [4, 10]
    end
  end
end
