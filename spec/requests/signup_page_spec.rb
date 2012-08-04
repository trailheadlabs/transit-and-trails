require "spec_helper"

describe "signup page" do
  it "displays the signup form" do
    visit '/users/sign_up'
    page.should have_content("Sign up")
  end

  it "signs up new users" do
    visit '/users/sign_up'
    page.should have_content("Sign up")
    fill_in 'Username', with: 'newuser'
    fill_in 'Email', with: 'newuser@email.com'
    fill_in 'Password', with: 'please'
    fill_in 'Password confirmation', with: 'please'
    click_button 'Sign up'
    page.should have_content 'A message with a confirmation link has been sent to your email address.'
  end

  it "requires email" do
    visit '/users/sign_up'
    page.should have_content("Sign up")
    fill_in 'Username', with: 'newuser'
    fill_in 'Password', with: 'please'
    fill_in 'Password confirmation', with: 'please'
    click_button 'Sign up'
    page.should have_selector "#error_explanation"
  end

end
