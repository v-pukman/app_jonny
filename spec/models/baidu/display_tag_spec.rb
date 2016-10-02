require 'rails_helper'

RSpec.describe Baidu::DisplayTag, type: :model do
  let(:display_tag) { create :baidu_display_tag }

  it "has a factory" do
    expect(display_tag.persisted?).to eq true
  end
end
