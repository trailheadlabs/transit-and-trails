# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_profile do
    firstname "MyString"
    lastname "MyString"
    url "MyString"
    bio "MyText"
  end
end
