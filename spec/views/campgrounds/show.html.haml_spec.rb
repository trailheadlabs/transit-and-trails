require 'spec_helper'

describe "campgrounds/show" do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @ability = Ability.new(@user)
    assign(:current_ability, @ability)
    controller.stub(:current_user, @user)
    view.stub(:current_user, @user)

    @campground = assign(:campground, stub_model(Campground,
      :name => "Name",
      :description => "MyText",
      :latitude => 1.5,
      :longitude => 1.5,
      :user => nil,
      :park => nil,
      :approved => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
  end
end
