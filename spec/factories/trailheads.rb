# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trailhead do
    sequence(:name) {|n| "Trailhead_#{n}" }
    description "MyText"
    latitude 37.8322173645
    longitude -122.212514877
    user nil
    rideshare false
    zimride_url "MyString"
    approved false
  end
end
