require "spec_helper"

describe "home page" do
  it "displays the home page" do
    visit "/"
    page.should have_content("Welcome")
  end

  it "should have a link to the open space council" do
    visit "/"
    page.should have_selector ".openspacecouncil-logo"
  end
end
