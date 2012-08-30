require 'spec_helper'

describe Trailhead do
  it "returns a park by bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    trailhead.park_by_bounds.id.should eq park.id
  end

  it "auto approves" do
    admin = FactoryGirl.create(:admin)
    trailhead = FactoryGirl.create(:trailhead, :user => admin)
    trailhead.should be_approved
  end
end
