FactoryGirl.define do
  factory :baidu_app, class: 'Baidu::App' do
    app_type 'game'
    sequence :packageid
    sequence :groupid
    sequence :docid
  end

  factory :baidu_board, class: 'Baidu::Board' do
    sequence :link do |s|
      "appsrv?native_api=1&sorttype=soft&boardid=board_#{Time.now.to_i}_#{s}&action=generalboard"
    end
  end

  factory :baidu_developer, class: 'Baidu::Developer' do
    sequence :origin_id
    sequence :name do |s|
      "developer##{s}"
    end
  end

  # factory :baidu_comment, class: 'Baidu::Comment' do
  # end

  # factory :baidu_day, class: 'Baidu::Day' do
  # end

  factory :baidu_rank, class: 'Baidu::Rank' do
    rank_type Baidu::Rank::SOFT_COMMON_RANK
    day { Date.today }
    sequence :rank_number
    association :app, factory: :baidu_app, app_type: Baidu::App::SOFT_APP
  end

  factory :baidu_category, class: 'Baidu::Category' do
    sequence :origin_id
    sequence :name do |s|
      "category##{s}"
    end
  end

  factory :baidu_tag, class: 'Baidu::Tag' do
    sequence :name do |s|
      "tag##{s}"
    end
  end

  factory :baidu_display_tag, class: 'Baidu::DisplayTag' do
    sequence :name do |s|
      "display_tag##{s}"
    end
  end

  factory :baidu_source, class: 'Baidu::Source' do
    sequence :name
  end

  factory :log do
    level Log::ERROR_LEVEL
    area Log::BAIDU_AREA
    message 'boom!'
  end

  #stats
  factory :baidu_track_app, class: 'Baidu::Track::App' do
    association :app, factory: :baidu_app
    day { Date.today }
  end

  factory :baidu_track_developer, class: 'Baidu::Track::Developer' do
    association :developer, factory: :baidu_developer
    day { Date.today }
  end
end
