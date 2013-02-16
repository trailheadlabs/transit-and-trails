# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favorite do
    favorable_id 1
    favorable_type "MyString"
    user nil
  end
end
