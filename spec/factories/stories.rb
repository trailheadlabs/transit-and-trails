# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    storytellable_id 1
    storytellable_type "MyString"
    user nil
    story "MyText"
    happened_at "2012-08-23 14:44:19"
    to_travel_mode_id 1
    from_travel_mode_id 1
  end
end
