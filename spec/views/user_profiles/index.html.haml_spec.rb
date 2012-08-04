require 'spec_helper'

describe "user_profiles/index" do
  before(:each) do
    assign(:user_profiles, [
      stub_model(UserProfile,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :url => "Url",
        :bio => "MyText"
      ),
      stub_model(UserProfile,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :url => "Url",
        :bio => "MyText"
      )
    ])
  end

  it "renders a list of user_profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
