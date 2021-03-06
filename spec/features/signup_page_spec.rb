require "spec_helper"

describe "signup page" do
  it "displays the signup form" do
    visit '/users/sign_up'
    page.should have_content("Sign Up")
  end

  it "signs up new users" do
    visit '/users/sign_up'
    page.should have_content("Sign Up")
    fill_in 'Username', with: 'newuser'
    fill_in 'Email', with: 'newuser@email.com'
    fill_in 'user_password', with: 'please'
    fill_in 'Password confirmation', with: 'please'
    click_button 'Sign Up'
    page.should have_content 'A message with a confirmation link has been sent to your email address.'
  end

  it "requires email" do
    visit '/users/sign_up'
    page.should have_content("Sign Up")
    fill_in 'Username', with: 'newuser'
    fill_in 'user_password', with: 'please'
    fill_in 'Password confirmation', with: 'please'
    click_button 'Sign Up'
    page.should have_selector ".email.field_with_errors"
  end

end
