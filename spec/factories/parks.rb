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
    bounds "MULTIPOLYGON (((-122.2380065698992126 37.8401568302505851, -122.1586990137642914 37.8397501331575157, -122.1561240931106056 37.7981196089912856, -122.2386932154044530 37.7979839663169344, -122.2380065698992126 37.8401568302505851)))"
    slug "MyText"
  end
end
