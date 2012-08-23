# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    name "MyString"
    description "MyText"
    user nil
    intensity nil
    duration nil
    starting_trailhead_id 1
    ending_trailhead_id 1
    route "MyText"
  end
end
