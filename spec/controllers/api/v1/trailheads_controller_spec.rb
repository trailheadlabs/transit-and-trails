require 'spec_helper'

describe Api::V1::TrailheadsController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      10.times do
        FactoryGirl.create(:trailhead)
      end
      get :index
      response.should be_success
      list = JSON.parse(response.body)
      list.class.should eq Array
      list.length.should eq 10
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      trailhead = FactoryGirl.create(:trailhead, :user => user)
      park = FactoryGirl.create(:park)
      Trailhead.any_instance.should_receive(:park_by_bounds).any_number_of_times.and_return(park)
      get :show, {:id=>trailhead.id}
      response.should be_success
      object = JSON.parse(response.body)
      object['id'].should eq trailhead.id
      object['author_id'].should eq user.id
      object['name'].should eq trailhead.name
      object['description'].should eq trailhead.description
      object['latitude'].should eq trailhead.latitude
      object['longitude'].should eq trailhead.longitude
      object['park_name'].should eq park.name
    end
  end

end
