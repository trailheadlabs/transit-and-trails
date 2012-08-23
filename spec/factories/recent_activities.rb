# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recent_activity do
    name "MyString"
    description "MyText"
    highlighted false
    recent_news_text "MyText"
    favorites_link1 "MyString"
    favorites_type1 "MyString"
    favorites_link2 "MyString"
    favorites_type2 "MyString"
    favorites_link3 "MyString"
    favorites_type3 "MyString"
    favorites_link4 "MyString"
    favorites_type4 "MyString"
    favorites_link5 "MyString"
    favorites_type5 "MyString"
    favorites_link1_text "MyText"
    favorites_link2_text "MyText"
    favorites_link3_text "MyText"
    favorites_link4_text "MyText"
    favorites_link5_text "MyText"
  end
end
