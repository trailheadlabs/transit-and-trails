require 'spec_helper'

describe "trips/edit" do
  before(:each) do
    view_sign_in
    @trip = assign(:trip, stub_model(Trip,
      :name => "MyString",
      :description => "MyText",
      :user => nil,
      :intensity => nil,
      :duration => nil,
      :starting_trailhead_id => 1,
      :ending_trailhead_id => 1,
      :route => "MyText"
    ))
  end

  it "renders the edit trip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trips_path(@trip), :method => "post" do
      assert_select "input#trip_name", :name => "trip[name]"
      assert_select "textarea#trip_description", :name => "trip[description]"
      assert_select "input", :name => "trip[intensity_id]"
      assert_select "input", :name => "trip[duration_id]"
      assert_select "input#trip_starting_trailhead_id", :name => "trip[starting_trailhead_id]"
      assert_select "input#trip_ending_trailhead_id", :name => "trip[ending_trailhead_id]"
    end
  end
end
