require 'rails_helper'

RSpec.describe Baidu::Day, type: :model do
  it "has factory" do
    day = create :baidu_day
    expect(day.persisted?).to eq true
  end
end
