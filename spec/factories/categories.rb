# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    description "MyText"
    visible false
    rank 1
  end
end
