require 'spec_helper'

describe Park do
  it "returns trailheads in bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    park.trailheads.count.should eq 1
    park.trailheads.first.should eq trailhead
  end

  it "returns if a trails is contained in it's bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    park.contains_trailhead?(trailhead).should be true
    park.trailheads_in_bounds.should include trailhead
  end

  it "returns trips starting in bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    trip = FactoryGirl.create(:trip,:starting_trailhead_id=>trailhead.id)
    park.contains_trailhead?(trailhead).should be true
    park.trailheads_in_bounds.should include trailhead
    trip.starting_trailhead_id.should eq trailhead.id
    park.trips_starting_in_bounds.should_not be_nil
    trip.starting_trailhead_id.should eq trailhead.id
    park.trips_starting_in_bounds.first.should eq trip
  end

  it "returns trips ending in bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    trip = FactoryGirl.create(:trip,:ending_trailhead_id=>trailhead.id)
    park.trips_ending_in_bounds.first.should eq trip
  end

  it "returns trips in bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    starting_trip = FactoryGirl.create(:trip,:starting_trailhead_id=>trailhead.id)
    ending_trip = FactoryGirl.create(:trip,:ending_trailhead_id=>trailhead.id)
    park.trips.should include starting_trip
    park.trips.should include ending_trip
  end

end
