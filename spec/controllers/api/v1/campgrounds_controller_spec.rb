require 'spec_helper'

describe Api::V1::CampgroundsController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      10.times do
        FactoryGirl.create(:campground)
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
      campground = FactoryGirl.create(:campground, :user => user)
      park = FactoryGirl.create(:park)
      Campground.any_instance.should_receive(:default_park).any_number_of_times.and_return(park)
      get :show, {:id=>campground.id}
      response.should be_success
      object = JSON.parse(response.body)
      object['id'].should eq campground.id
      object['author_id'].should eq user.id
      object['name'].should eq campground.name
      object['description'].should eq campground.description
      object['latitude'].should eq campground.latitude
      object['longitude'].should eq campground.longitude
      object['park_name'].should eq park.name
    end
  end

  describe "GET 'maps" do
    it "returns campground maps" do
      campground = FactoryGirl.create(:campground)
      3.times do
        FactoryGirl.create(:map,:mapable_type=>'Campground',:mapable_id=>campground.id)
      end
      get :maps, {:id=>campground.id}
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
      object[0]['url'].should eq "MyString"
    end
  end

  describe "GET 'attributes" do
    it "returns campground attributes" do
      campground = FactoryGirl.create(:campground)
      category = FactoryGirl.create(:category, :name=>'Test')
      3.times do
        attribute = FactoryGirl.create(:campground_feature,:category=>category)
        campground.campground_features << attribute
      end
      get :attributes, {:id=>campground.id}
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

  describe "GET 'photos" do
    it "returns campground photos" do
      campground = FactoryGirl.create(:campground)
      3.times do
        FactoryGirl.create(:photo,:photoable_type=>'Campground',:photoable_id=>campground.id)
      end
      get :photos, {:id=>campground.id}
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
    end
  end

end
