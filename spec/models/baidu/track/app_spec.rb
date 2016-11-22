require 'rails_helper'

RSpec.describe Baidu::Track::App do
  let(:track) { create :baidu_track_app }
  before do
    allow(Baidu::Service::Track::App).to receive(:save_track).and_return(nil)
  end

  it "has a factory" do
    track = create :baidu_track_app
    expect(track.persisted?).to eq true
  end

  it "belongs to baidu app" do
    expect(track.app.class).to eq Baidu::App
  end

  describe ".not_tracked_ids_sliced" do
    let(:day) { Date.today }
    let(:ids) { (1..15000).to_a }
    let(:ids2) { (1..30000).to_a }
    let(:ids3) { (1..90000).to_a }
    it "returns sliced array" do
      allow(Baidu::Analytic::App).to receive(:not_tracked_ids).and_return(ids)
      expect(Baidu::Track::App.not_tracked_ids_sliced(day).count).to eq 1
      allow(Baidu::Analytic::App).to receive(:not_tracked_ids).and_return(ids2)
      expect(Baidu::Track::App.not_tracked_ids_sliced(day).count).to eq 2
      allow(Baidu::Analytic::App).to receive(:not_tracked_ids).and_return(ids3)
      expect(Baidu::Track::App.not_tracked_ids_sliced(day).count).to be > 2
    end
  end
end
