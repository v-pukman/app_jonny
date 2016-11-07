require 'rails_helper'

RSpec.describe Baidu::Service::Track::App do
  let(:service) { Baidu::Service::Track::App }
  let(:app) { create :baidu_app }

  before do
    app.tracks = []
  end

  describe ".save_track" do
    it "creates track record" do
      track = service.save_track app
      expect(track.persisted?).to eq true
    end
    it "updates fields from app record" do
      attrs = service.build_attrs app
      track = service.save_track app
      attrs.each do |k, v|
        expect(track.send("#{k}")).to eq v
      end
    end
    it "returns already saved track for curr day" do
      track = create :baidu_track_app, app: app
      track2 = service.save_track app
      expect(track2.id).to eq track.id
    end
    it "updates already saved track" do
      track = create :baidu_track_app, app: app
      allow(app).to receive_message_chain(:tracks, :where).and_return([track])
      expect(track).to receive(:update_attributes)
      service.save_track app
    end
    it "handles ActiveRecord::RecordNotUnique error" do
      attrs = service.build_attrs app
      track = create :baidu_track_app, app: app
      tracks = double
      allow(tracks).to receive(:where).and_return([track])
      allow(app).to receive(:tracks).and_return(tracks)
      allow(track).to receive(:nil?).and_raise(ActiveRecord::RecordNotUnique, "not_uniq error")
      expect(track).to receive(:update_attributes).with(attrs)
      service.save_track app
    end
    it "creates log on StandardError" do
      track = create :baidu_track_app, app: app
      tracks = double
      allow(tracks).to receive(:where).and_return([track])
      allow(app).to receive(:tracks).and_return(tracks)
      allow(track).to receive(:nil?).and_raise(StandardError, "error")
      service.save_track app
      log = Log.where(method_name: 'save_track').first
      expect(log).to_not eq nil
      expect(log.context['app_id']).to eq app.id
    end
  end

  describe ".build_attrs" do
    let(:attrs) { service.build_attrs app }
    it "returns attrs" do
      expect(attrs.empty?).to eq false
    end
    context "doesn't include" do
      it { expect(attrs[:updated_at]).to eq nil }
      it { expect(attrs[:created_at]).to eq nil }
      it { expect(attrs[:id]).to eq nil }
    end
    it "includes curr day" do
      expect(attrs[:day]).to_not eq nil
    end
  end
end
