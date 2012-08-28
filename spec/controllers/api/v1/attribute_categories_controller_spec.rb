require "spec_helper"

describe Api::V1::AttributeCategoriesController do
  render_views

  describe "GET index" do
    it "returns a list of users" do
      3.times do
        category = FactoryGirl.create(:category)
      end

      get :index
      response.status.should eq 200
      list = JSON.parse(response.body)
      list.count.should eq 3
    end
  end

  describe "GET show" do
    it "returns a user" do
      category = FactoryGirl.create(:category)
      get :show, {:id=>category.id}
      response.status.should eq 200
      object = JSON.parse(response.body)
      object['id'].should eq category.id
      object['name'].should eq category.name
      object['description'].should eq category.description
    end
  end
end


