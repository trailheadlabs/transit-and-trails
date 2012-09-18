# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campground do
    sequence(:name) {|n| "Campground_#{n}" }
    description "MyText"
    latitude 1.5
    longitude 1.5
    user nil
    park nil
    approved false
  end
end
