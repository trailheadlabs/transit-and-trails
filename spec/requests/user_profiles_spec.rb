require 'spec_helper'

describe "UserProfiles" do
  describe "GET /profile" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      user = FactoryGirl.create(:user)
      user.username.should_not be_nil
      visit "/users/sign_in"
      fill_in "Username", with: user.username
      fill_in "Password", with: "please"
      click_button "Sign In"
      page.should have_content user.username
      visit profile_path
      current_path.should == profile_path
    end
  end
end
