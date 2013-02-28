require "spec_helper"

describe Api::V1::UsersController do
  render_views

  describe "GET index" do
    it "returns a list of users" do
      user = FactoryGirl.create(:user)
      user_profile = FactoryGirl.create(:user_profile,:user=>user)
      get :index
      response.status.should eq 200
      list = JSON.parse(response.body)
      list.count.should eq 1
    end
  end

  describe "GET show" do
    it "returns a user" do
      user = FactoryGirl.create(:user)
      user_profile = FactoryGirl.create(:user_profile,:user=>user)
      get :show, {:id=>user.id}
      response.status.should eq 200
      object = JSON.parse(response.body)
      object['id'].should eq user.id
      object['username'].should eq user.username
      object['first_name'].should eq user.user_profile.firstname
      object['last_name'].should eq user.user_profile.lastname
      object['avatar_url'].should eq user_profile.avatar.url
      object['avatar_thumbnail_url'].should eq user_profile.avatar.thumbnail.url
      object['organization_avatar_url'].should eq user_profile.organization_avatar.url
      object['organization_avatar_thumbnail_url'].should eq user_profile.organization_avatar.thumbnail.url
      object['organization_name'].should eq user_profile.organization_name
      object['website_url'].should eq user_profile.website_address
    end
  end
end


