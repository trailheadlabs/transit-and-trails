# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :park do
    name "MyString"
    description "MyText"
    agency nil
    acres 1
    county "MyString"
    county_slug "MyString"
    non_profit_partner nil
    bounds "MyText"
    slug "MyText"
  end
end
