require "spec_helper"

describe "rails admin" do
  it "displays the login form" do
    visit '/admin'
    page.should have_content("Sign in")
  end

  it "let's admin users in" do
    user = FactoryGirl.create(:admin)
    user.admin.should be_true
    visit '/admin'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'please'
    click_on 'Sign in'
    page.should_not have_content 'Sign in'
  end

end
