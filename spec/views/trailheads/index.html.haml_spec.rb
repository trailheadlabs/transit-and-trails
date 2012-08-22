require 'spec_helper'

describe "trailheads/index" do
  before(:each) do
    assign(:trailheads, [
      stub_model(Trailhead,
        :name => "Name",
        :description => "MyText",
        :latitude => 1.5,
        :longitude => 1.5,
        :user => nil,
        :rideshare => false,
        :zimride_url => "Zimride Url"
      ),
      stub_model(Trailhead,
        :name => "Name",
        :description => "MyText",
        :latitude => 1.5,
        :longitude => 1.5,
        :user => nil,
        :rideshare => false,
        :zimride_url => "Zimride Url"
      )
    ])
  end

  it "renders a list of trailheads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 4
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Zimride Url".to_s, :count => 2
  end
end
