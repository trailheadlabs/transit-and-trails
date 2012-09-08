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
      :route => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)

  end
end
