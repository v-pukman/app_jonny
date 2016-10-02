require 'rails_helper'

RSpec.describe Baidu::Category, type: :model do
  let(:category) { create :baidu_category }

  it "has a factory" do
    expect(category.persisted?).to eq true
  end
end
