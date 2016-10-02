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

  # factory :baidu_rank, class: 'Baidu::Rank' do
  # end

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
end
