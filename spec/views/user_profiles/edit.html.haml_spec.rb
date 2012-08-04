require 'spec_helper'

describe "user_profiles/edit" do
  before(:each) do
    @user_profile = assign(:user_profile, stub_model(UserProfile,
      :firstname => "MyString",
      :lastname => "MyString",
      :url => "MyString",
      :bio => "MyText"
    ))
  end

  it "renders the edit user_profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_profiles_path(@user_profile), :method => "post" do
      assert_select "input#user_profile_firstname", :name => "user_profile[firstname]"
      assert_select "input#user_profile_lastname", :name => "user_profile[lastname]"
      assert_select "input#user_profile_url", :name => "user_profile[url]"
      assert_select "textarea#user_profile_bio", :name => "user_profile[bio]"
    end
  end
end
