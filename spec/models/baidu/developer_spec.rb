require 'rails_helper'

RSpec.describe Baidu::Developer, type: :model do
  let(:developer) { create :baidu_developer }

  it "has a factory" do
    expect(developer.persisted?).to eq true
  end

  it "saves track" do
    [developer]
    developer.score = 105
    expect(Baidu::Service::Track::Developer).to receive(:save_track).with(developer)
    developer.save
  end
end
