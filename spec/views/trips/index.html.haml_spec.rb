require 'spec_helper'

describe "trips/index" do
  before(:each) do
    assign(:trips, [
      stub_model(Trip,
        :name => "Name",
        :description => "MyText",
        :user => nil,
        :intensity => nil,
        :duration => nil,
        :starting_trailhead_id => 1,
        :ending_trailhead_id => 2,
        :route => "MyText"
      ),
      stub_model(Trip,
        :name => "Name",
        :description => "MyText",
        :user => nil,
        :intensity => nil,
        :duration => nil,
        :starting_trailhead_id => 1,
        :ending_trailhead_id => 2,
        :route => "MyText"
      )
    ])
  end

  it "renders a list of trips" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 4
    assert_select "tr>td", :text => nil.to_s, :count => 6
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
