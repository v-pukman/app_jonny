require 'rails_helper'

RSpec.describe "RedisClient" do
  it "allows set values" do
    RedisClient.set("mykey", "hello world")
    expect(RedisClient.get("mykey")).to eq "hello world"
  end
end
