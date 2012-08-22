# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trailhead_feature do
    name "MyString"
    description "MyText"
    marker_icon "MyString"
    rank 1
    link_url "MyString"
    category nil
  end
end
