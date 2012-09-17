require 'spec_helper'

describe "trailheads/new" do
  before(:each) do
    view_sign_in
    assign(:trailhead, stub_model(Trailhead,
      :name => "MyString",
      :description => "MyText",
      :latitude => 1.5,
      :longitude => 1.5,
      :user => nil,
      :rideshare => false,
      :zimride_url => "MyString"
    ).as_new_record)
  end

  it "renders new trailhead form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trailheads_path, :method => "post" do
      assert_select "input#id_name", :name => "trailhead[name]"
      assert_select "textarea#trailhead_description", :name => "trailhead[description]"
      assert_select "input#trailhead_latitude", :name => "trailhead[latitude]"
      assert_select "input#trailhead_longitude", :name => "trailhead[longitude]"
    end
  end
end
