require "spec_helper"

describe "login page" do
  it "displays the login form" do
    visit '/users/sign_in'
    page.should have_content("Sign in")
  end

  it "logs users in" do
    user = FactoryGirl.create(:user)
    visit '/users/sign_in'
    fill_in 'Login', with: user.username
    fill_in 'Password', with: 'please'
    click_on 'Sign in'
    page.should have_content user.username
  end

  it "logs imported users in" do
    user = FactoryGirl.build(:django_user)
    user.save(validate: false)
    user.encrypted_password.should be_blank
    visit '/users/sign_in'
    fill_in 'Login', with: user.username
    fill_in 'Password', with: 'password'
    click_on 'Sign in'
    page.should have_content user.username
    User.find_by_username('djangouser').encrypted_password.should_not be_blank
  end

end
