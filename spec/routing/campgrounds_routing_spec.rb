require "spec_helper"

describe CampgroundsController do
  describe "routing" do

    it "routes to #index" do
      get("/campgrounds").should route_to("campgrounds#index")
    end

    it "routes to #new" do
      get("/campgrounds/new").should route_to("campgrounds#new")
    end

    it "routes to #show" do
      get("/campgrounds/1").should route_to("campgrounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/campgrounds/1/edit").should route_to("campgrounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/campgrounds").should route_to("campgrounds#create")
    end

    it "routes to #update" do
      put("/campgrounds/1").should route_to("campgrounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/campgrounds/1").should route_to("campgrounds#destroy", :id => "1")
    end

  end
end
