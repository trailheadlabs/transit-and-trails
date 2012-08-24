# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regional_landing_page do
    name "MyString"
    description "MyText"
    path "MyString"
    latitude 1.5
    longitude 1.5
  end
end
