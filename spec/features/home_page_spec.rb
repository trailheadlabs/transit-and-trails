require "spec_helper"

describe "home page" do
  before :each do
    FactoryGirl.create(:trip_feature, :name => "Featured")
  end

  it "displays the home page" do
    visit "/"
    page.should have_content("Transit & Trails")
  end

  it "should have a link to the open space council" do
    visit "/"
    page.should have_selector ".openspacecouncil-logo"
  end
end
