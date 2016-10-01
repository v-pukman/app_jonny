class Baidu::Service::Board < Baidu::Service::Base
  def download_boards
    boards_info = api.get :boards, sorttype: 'soft'
    save_boards build_boards_attrs(boards_info)

    boards_info = api.get :boards, sorttype: 'game'
    save_boards build_boards_attrs(boards_info)
  end

  def build_boards_attrs boards_info
    links = boards_info.to_s.scan /appsrv[\S]+/
    links = links.map {|l| l.gsub('",', '') }

    links.map do |link|
      { link: link }
    end
  end

  def save_boards boards_attrs
    boards_attrs.each do |attrs|
      begin
        if Baidu::Board.where(link: attrs[:link]).count.zero?
          board = Baidu::Board.new(attrs)
          board.save!
        end
      rescue => e
        p "save_boards error: #{e.message}"
      end
    end
  end
end
