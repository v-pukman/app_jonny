require 'rails_helper'

RSpec.describe Baidu::Service::Base do
  it "returns baidu api instance" do
    service = Baidu::Service::Base.new
    expect(service.api.class.name).to eq 'Baidu::Service::ApiClient'
  end
end
