require 'spec_helper'

describe "Campgrounds" do
  describe "GET /campgrounds" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get campgrounds_path
      response.status.should be(302)
    end
  end
end
