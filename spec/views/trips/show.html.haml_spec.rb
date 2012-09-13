require 'spec_helper'

describe "trips/show" do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @ability = Ability.new(@user)
    assign(:current_ability, @ability)
    controller.stub(:current_user, @user)
    view.stub(:current_user, @user)
    starting_trailhead = FactoryGirl.create(:trailhead)

    @trip = assign(:trip, stub_model(Trip,
      :name => "Name",
      :description => "MyText",
      :user => @user,
      :intensity => FactoryGirl.create(:intensity),
      :duration => FactoryGirl.create(:duration),
      :starting_trailhead => starting_trailhead,
      :ending_trailhead => starting_trailhead,
      :route => "[[37.8322173645,-122.21251487699999],[37.82038707077789,-122.20015992431638],[37.8318217249,-122.18518317400003]]",
      :geometry => "LINESTRING (-122.2125148769999896 37.8322173645000035, -122.2001599243163810 37.8203870707778904, -122.1851831740000307 37.8318217249000028)"

    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)

  end
end
