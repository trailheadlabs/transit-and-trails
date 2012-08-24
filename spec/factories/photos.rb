# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    photoable_id 1
    photoable_type "MyString"
    flickr_id "MyString"
    user nil
    uploaded_to_flickr false
    image "MyString"
  end
end
