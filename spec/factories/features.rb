# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    name "MyString"
    description "MyText"
    link_url "MyText"
    rank 1
    category nil
  end
end
