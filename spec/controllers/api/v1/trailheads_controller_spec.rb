require 'spec_helper'

describe Api::V1::TrailheadsController do
  render_views
  # let(:params)  { { :key=>FactoryGirl.create(:user_profile).api_key } }
  let(:params) { { :key => FactoryGirl.create(:user_profile).api_key } }

  describe "GET 'index'" do
    it "returns a list of trailheads" do
      10.times do
        FactoryGirl.create(:trailhead)
      end
      Trailhead.all.count.should eq 10
      get :index, params
      response.should be_success
      list = JSON.parse(response.body)
      list.class.should eq Array
      list.length.should eq 10
    end
  end


  describe "GET 'index'" do
    it "returns a sublist of trailheads" do
      10.times do
        FactoryGirl.create(:trailhead)
      end
      get :index, params.merge(:limit=>3)
      response.should be_success
      list = JSON.parse(response.body)
      list.class.should eq Array
      list.length.should eq 3
    end
  end

  describe "GET 'show'" do
    it "returns a trailhead with the right fields" do
      user = FactoryGirl.create(:user)
      trailhead = FactoryGirl.create(:trailhead, :user => user)
      park = FactoryGirl.create(:park)
      Trailhead.any_instance.should_receive(:default_park).any_number_of_times.and_return(park)
      get :show, params.merge(:id=>trailhead.id)
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

  describe "GET 'maps" do
    it "returns trailhead maps" do
      trailhead = FactoryGirl.create(:trailhead)
      3.times do
        FactoryGirl.create(:map,:mapable_type=>'Trailhead',:mapable_id=>trailhead.id)
      end
      get :maps, params.merge(:id=>trailhead.id)
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
      object[0]['url'].should eq "MyString"
    end
  end

  describe "GET 'attributes" do
    it "returns trailhead attributes" do
      trailhead = FactoryGirl.create(:trailhead)
      category = FactoryGirl.create(:category, :name=>'Test')
      3.times do
        attribute = FactoryGirl.create(:trailhead_feature,:category=>category)
        trailhead.trailhead_features << attribute
      end
      get :attributes, params.merge(:id=>trailhead.id)
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
    it "returns trailhead photos" do
      trailhead = FactoryGirl.create(:trailhead)
      3.times do
        FactoryGirl.create(:photo,:photoable_type=>'Trailhead',:photoable_id=>trailhead.id)
      end
      Photo.any_instance.stub(:flickr_url).and_return('http://flickr.com')
      get :photos, params.merge(:id=>trailhead.id)
      response.should be_success
      object = JSON.parse(response.body)
      object.class.should eq Array
    end
  end

end
