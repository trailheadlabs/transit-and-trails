require "spec_helper"

describe "login page" do
  it "displays the login form" do
    visit '/users/sign_in'
    page.should have_content("Sign In")
  end

  it "logs users in" do
    user = FactoryGirl.create(:user)
    visit '/users/sign_in'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'please'
    within("form") do
      click_on 'Sign In'
    end
    page.should have_content user.username
  end

  it "logs imported users in" do
    user = FactoryGirl.build(:django_user)
    user.save(validate: false)
    user.encrypted_password.should be_blank
    visit '/users/sign_in'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'password'
    within("form") do
      click_on 'Sign In'
    end
    page.should have_content user.username
    User.find_by_username('djangouser').encrypted_password.should_not be_blank
  end

  it "doesn't log in bad users" do
    visit '/users/sign_in'
    fill_in 'Username', with: 'noway'
    fill_in 'Password', with: 'password'
    within("form") do
      click_on 'Sign In'
    end
    page.should have_content 'Invalid'
    page.should_not have_content 'noway'
  end

end
