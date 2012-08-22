# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trailhead do
    name "MyString"
    description "MyText"
    latitude 1.5
    longitude 1.5
    user nil
    rideshare false
    zimride_url "MyString"
    approved true
  end
end
