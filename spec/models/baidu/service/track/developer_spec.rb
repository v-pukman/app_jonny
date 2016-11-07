require 'rails_helper'

RSpec.describe Baidu::Service::Track::Developer do
  let(:service) { Baidu::Service::Track::Developer }
  let(:developer) { create :baidu_developer }

  before do
    developer.tracks = []
  end

  describe ".save_track" do
    it "creates track record" do
      track = service.save_track developer
      expect(track.persisted?).to eq true
    end
    it "set score" do
      developer.update_attributes score: 5
      track = service.save_track developer
      expect(track.score).to eq 5
    end
    it "set level" do
      developer.update_attributes level: 100
      track = service.save_track developer
      expect(track.level).to eq 100
    end
    context "when score and level are not changed" do
      it "doesn't create track" do
        attrs = { score: 5, level: 15 }
        developer.update_attributes attrs
        developer.tracks = []
        track = create :baidu_track_developer, attrs.merge(day: Date.today, developer_id: developer.id)
        track2 = service.save_track developer
        expect(track2.id).to eq track.id
      end
    end

     it "handles ActiveRecord::RecordNotUnique error" do
      attrs = service.build_attrs developer
      track = create :baidu_track_developer, developer: developer
      tracks = double
      allow(developer).to receive(:tracks).and_return(tracks)
      allow(tracks).to receive(:where).and_return([track])
      allow(track).to receive(:nil?).and_raise(ActiveRecord::RecordNotUnique, "not_uniq error")
      expect(track).to receive(:update_attributes).with(attrs)
      service.save_track developer
    end
    it "creates log on StandardError" do
      track = create :baidu_track_developer, developer: developer
      tracks = double
      allow(developer).to receive(:tracks).and_return(tracks)
      allow(tracks).to receive(:where).and_return([track])
      allow(track).to receive(:nil?).and_raise(StandardError, "error")
      service.save_track developer
      log = Log.where(method_name: 'save_track').first
      expect(log).to_not eq nil
      expect(log.context['developer_id']).to eq developer.id
    end
  end
end
