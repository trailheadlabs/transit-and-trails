require 'spec_helper'

describe "campgrounds/new" do
  before(:each) do
    view_sign_in
    assign(:campground, stub_model(Campground,
      :name => "MyString",
      :description => "MyText",
      :latitude => 1.5,
      :longitude => 1.5,
      :user => nil,
      :park => nil,
      :approved => false
    ).as_new_record)
  end

  it "renders new campground form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => campgrounds_path, :method => "post" do
      assert_select "input#id_name", :name => "campground[name]"
      assert_select "textarea#campground_description", :name => "campground[description]"
      assert_select "input#trailhead_latitude", :name => "campground[latitude]"
      assert_select "input#trailhead_longitude", :name => "campground[longitude]"
      assert_select "input#campground_approved", :name => "campground[approved]"
    end
  end
end
