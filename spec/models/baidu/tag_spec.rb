require 'rails_helper'

RSpec.describe Baidu::Tag, type: :model do
  let(:tag) { create :baidu_tag }

  it "has a factory" do
    expect(tag.persisted?).to eq true
  end
end
