require 'rails_helper'

RSpec.describe Baidu::Source, type: :model do
  let(:source) { create :baidu_source }

  it "has as factory" do
    expect(source.persisted?).to eq true
  end
end
