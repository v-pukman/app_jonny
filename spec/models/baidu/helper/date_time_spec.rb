require 'rails_helper'

RSpec.describe Baidu::Helper::DateTime do
  let(:helper) { Baidu::Helper::DateTime }
  it "returns current time" do
    expect(helper.curr_time.class).to eq Time
  end
  it "returns current date" do
    expect(helper.curr_date.class).to eq Date
  end
  it "returns time_with_zone" do
    expect(helper.time_with_zone.class).to eq ActiveSupport::TimeWithZone
  end
end
