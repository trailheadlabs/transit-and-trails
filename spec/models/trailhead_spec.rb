require 'spec_helper'

describe Trailhead do
  it "returns a park by bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    trailhead.park_by_bounds.id.should eq park.id
  end
end
