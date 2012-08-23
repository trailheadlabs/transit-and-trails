# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map do
    name "MyString"
    description "MyText"
    mapable_id 1
    mapable_type "MyString"
    url "MyString"
    user nil
    map "MyString"
  end
end
