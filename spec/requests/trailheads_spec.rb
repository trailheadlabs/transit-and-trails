require 'spec_helper'

describe "Trailheads" do
  describe "GET /trailheads" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get trailheads_path
      response.status.should be(302)
    end
  end
end
