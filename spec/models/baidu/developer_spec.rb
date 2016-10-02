require 'rails_helper'

RSpec.describe Baidu::Developer, type: :model do
  let(:developer) { create :baidu_developer }

  it "has a factory" do
    expect(developer.persisted?).to eq true
  end
end
