# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trailhead do
    name "MyString"
    description "MyText"
    latitude 37.832217364500003
    longitude -122.212514877
    user nil
    rideshare false
    zimride_url "MyString"
    approved true
  end
end
