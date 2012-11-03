require "spec_helper"

describe "rails admin" do
  it "displays the login form" do
    visit '/admin'
    page.should have_content("Sign In")
  end

  it "let's admin users in" do
    user = FactoryGirl.create(:admin)
    user.admin?.should be_true
    visit '/admin'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'please'
    click_on 'Sign In'
    page.should_not have_content 'Sign in'
  end

  it "doesn't let non admin users in" do
    user = FactoryGirl.create(:user)
    user.admin.should be_false
    visit '/admin'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'please'
    click_on 'Sign In'
    page.should_not have_content 'Sign in'
  end

end
