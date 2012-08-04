require 'spec_helper'

describe "UserProfiles" do
  describe "GET /user_profiles" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      user = FactoryGirl.create(:user)
      user.username.should_not be_nil
      visit "/users/sign_in"
      fill_in "Login", with: user.username
      fill_in "Password", with: "please"
      click_button "Sign in"
      page.should have_content user.username
      visit user_profiles_path
      page.should have_content "User Profiles"
      current_path.should == user_profiles_path
    end
  end
end
