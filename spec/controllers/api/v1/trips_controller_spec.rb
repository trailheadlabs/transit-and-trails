require 'spec_helper'

describe Api::V1::TripsController do
  render_views

  describe "GET 'index'" do
    it "returns a list of trips" do
      10.times do
        FactoryGirl.create(:trip)
      end
      get :index
      response.should be_success
      list = JSON.parse(response.body)
      list.class.should eq Array
      list.length.should eq 10
    end
  end

  describe "GET 'show'" do
    it "returns a trip with the right fields" do
      user = FactoryGirl.create(:user)
      duration = FactoryGirl.create(:duration,:name => "LongTime")
      intensity = FactoryGirl.create(:intensity,:name => "Slog")
      starting_trailhead = FactoryGirl.create(:trailhead,:name=>"Starting")
      ending_trailhead = FactoryGirl.create(:trailhead,:name=>"Ending")
      trip = FactoryGirl.create(:trip, :user => user,:duration=>duration,:intensity=>intensity,
        :starting_trailhead=>starting_trailhead,:ending_trailhead=>ending_trailhead)
      park = FactoryGirl.create(:park)
      get :show, {:id=>trip.id}
      response.should be_success
      object = JSON.parse(response.body)
      object['id'].should eq trip.id
      object['author_id'].should eq user.id
      object['name'].should eq trip.name
      object['description'].should eq trip.description
      object['duration'].should eq trip.duration.name
      object['intensity'].should eq trip.intensity.name
      object['ending_trailhead_id'].should eq ending_trailhead.id
      object['starting_trailhead_id'].should eq starting_trailhead.id
      object['length_miles'].round(1).should eq 2.2
    end
  end

  describe "GET 'maps'" do
    it "returns trip maps" do
      trip = FactoryGirl.create(:trip)
      3.times do
        FactoryGirl.create(:map,:mapable_type=>'Trip',:mapable_id=>trip.id)
      end
      get :maps, {:id=>trip.id}
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
      object[0]['url'].should eq "MyString"
    end
  end

  describe "GET 'attributes'" do
    it "returns trip attributes" do
      trip = FactoryGirl.create(:trip)
      category = FactoryGirl.create(:category, :name=>'Test')
      3.times do
        attribute = FactoryGirl.create(:trip_feature,:category=>category)
        trip.trip_features << attribute
      end
      get :attributes, {:id=>trip.id}
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
      object.length.should eq 3
      object[0]['id'].should_not be_blank
      object[0]['name'].should eq "MyString"
      object[0]['category'].should eq category.id
      object[0]['category_name'].should eq category.name
    end
  end

  describe "GET 'photos'" do
    it "returns trip photos" do
      trip = FactoryGirl.create(:trip)
      3.times do
        FactoryGirl.create(:photo,:photoable_type=>'Trip',:photoable_id=>trip.id)
      end
      get :photos, {:id=>trip.id}
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
    end
  end

  describe "GET 'route'" do
    it "returns trip route" do
      trip = FactoryGirl.create(:trip)
      get :route, {:id=>trip.id}
      response.should be_success
      object = JSON.parse(response.body)
      object['route'].should eq trip.route
    end
  end

end
