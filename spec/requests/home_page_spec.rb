require "spec_helper"

describe "home page" do
  it "displays the home page" do
    visit "/"
    page.should have_content("Transit & Trails")
  end

  it "should not display notice or alert" do
    page.should_not have_selector('.notice')
    page.should_not have_selector('.alert')
  end


end
