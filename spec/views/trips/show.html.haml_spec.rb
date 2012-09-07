require 'spec_helper'

describe "trips/show" do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @ability = Ability.new(@user)
    assign(:current_ability, @ability)
    controller.stub(:current_user, @user)
    view.stub(:current_user, @user)

    @trip = assign(:trip, stub_model(Trip,
      :name => "Name",
      :description => "MyText",
      :user => nil,
      :intensity => nil,
      :duration => nil,
      :starting_trailhead_id => 1,
      :ending_trailhead_id => 2,
      :route => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
  end
end
