require 'rails_helper'

RSpec.describe Baidu::App, type: :model do
  it "has factory" do
    app = create :baidu_app
    expect(app.persisted?).to eq true
  end
end
