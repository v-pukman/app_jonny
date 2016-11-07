require 'rails_helper'

RSpec.describe Baidu::Track::Developer do
  let(:track) { create :baidu_track_developer }

  before do
    allow(Baidu::Service::Track::Developer).to receive(:save_track).and_return(nil)
  end

  it "has a factory" do
    expect(track.persisted?).to eq true
  end

  it "belongs to baidu developer" do
    expect(track.developer.class).to eq Baidu::Developer
  end
end
