# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    sequence(:name) {|n| "Trip_#{n}" }
    description "MyText"
    user nil
    intensity nil
    duration nil
    association :starting_trailhead, factory: :trailhead, name: "starting"
    association :ending_trailhead, factory: :trailhead, name: "ending"
    route "[[37.8322173645,-122.21251487699999],[37.82038707077789,-122.20015992431638],[37.8318217249,-122.18518317400003]]"
    geometry "LINESTRING (-122.2125148769999896 37.8322173645000035, -122.2001599243163810 37.8203870707778904, -122.1851831740000307 37.8318217249000028)"
  end
end
