FactoryGirl.define do
  factory :baidu_app, class: 'Baidu::App' do
    app_type 'game'
    sequence :packageid
    sequence :groupid
    sequence :docid
  end

  factory :baidu_comment, class: 'Baidu::Comment' do
  end

  factory :baidu_day, class: 'Baidu::Day' do
  end

  factory :baidu_rank, class: 'Baidu::Rank' do
  end

  factory :baidu_board, class: 'Baidu::Board' do
  end

  factory :baidu_category, class: 'Baidu::Category' do
  end
  factory :baidu_tag, class: 'Baidu::Tag' do
  end

  factory :baidu_display_tag, class: 'Baidu::DisplayTag' do
    sequence :name
  end
end
