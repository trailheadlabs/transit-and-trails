require 'spec_helper'

describe "trailheads/show" do
  before(:each) do
    @trailhead = assign(:trailhead, stub_model(Trailhead,
      :name => "Name",
      :description => "MyText",
      :latitude => 1.5,
      :longitude => 1.5,
      :user => nil,
      :rideshare => false,
      :zimride_url => "Zimride Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(//)
    rendered.should match(/false/)
    rendered.should match(/Zimride Url/)
  end
end
