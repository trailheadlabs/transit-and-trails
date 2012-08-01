require "spec_helper"

describe "home page" do
  it "displays the home page" do
    visit "/"
    page.should have_content("Transit & Trails")
  end
end
