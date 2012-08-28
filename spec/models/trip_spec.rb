require 'spec_helper'

describe Trip do
  it "should return the right length" do
    trip = FactoryGirl.create(:trip)
    trip.length_miles.round(1).should eq 2.2
  end
end
