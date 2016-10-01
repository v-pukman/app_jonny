require 'rails_helper'

RSpec.describe Baidu::Service::Board do
  let(:boards_info) {  json_vcr_fixture('baidu/get_boards.yml') }
  let(:service) { Baidu::Service::Board.new }

  describe "#build_boards_attrs" do
    let(:attrs) { service.build_boards_attrs boards_info }
    it "retruns board attrs" do
      expect(attrs.count).to be > 0
      attrs.each do |a|
        expect(a[:link]).to include 'appsrv?'
      end
    end
  end

  describe "#save_boards" do
    let(:link1) { 'appsrv?native_api=1&sorttype=soft&boardid=board_100_10014&action=generalboard' }
    let(:link2) { 'appsrv?native_api=1&action=generalboard&boardid=board_100_019&subcateurl=true&sorttype=soft' }
    let(:attrs) do
      [
        { link: link1 },
        { link: link2 }
      ]
    end
    it "saves board records" do
      service.save_boards attrs
      board2 = Baidu::Board.where(link: link2).first
      expect(board2.persisted?).to eq true
      expect(board2.link).to eq link2
    end
  end

  describe "#download_boards" do
    it "call api to download soft and game boards" do
      expect(service.api).to receive(:get).with(:boards, sorttype: 'soft').and_return(boards_info)
      expect(service.api).to receive(:get).with(:boards, sorttype: 'game').and_return(boards_info)
      service.download_boards
    end
    it "download boards" do
      Baidu::Board.destroy_all
      VCR.use_cassette("baidu/get_boards") do
        VCR.use_cassette("baidu/get_boards--game") do
          service.download_boards
          expect(Baidu::Board.count).to be > 0
        end
      end
    end
  end
end
