require 'spec_helper'

describe "trailheads/edit" do
  before(:each) do
    @trailhead = assign(:trailhead, stub_model(Trailhead,
      :name => "MyString",
      :description => "MyText",
      :latitude => 1.5,
      :longitude => 1.5,
      :user => nil,
      :rideshare => false,
      :zimride_url => "MyString"
    ))
  end

  it "renders the edit trailhead form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trailheads_path(@trailhead), :method => "post" do
      assert_select "input#trailhead_name", :name => "trailhead[name]"
      assert_select "textarea#trailhead_description", :name => "trailhead[description]"
      assert_select "input#trailhead_latitude", :name => "trailhead[latitude]"
      assert_select "input#trailhead_longitude", :name => "trailhead[longitude]"
      assert_select "input#trailhead_user", :name => "trailhead[user]"
      assert_select "input#trailhead_rideshare", :name => "trailhead[rideshare]"
      assert_select "input#trailhead_zimride_url", :name => "trailhead[zimride_url]"
    end
  end
end
