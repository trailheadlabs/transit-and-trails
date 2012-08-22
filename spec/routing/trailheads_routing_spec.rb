require "spec_helper"

describe TrailheadsController do
  describe "routing" do

    it "routes to #index" do
      get("/trailheads").should route_to("trailheads#index")
    end

    it "routes to #new" do
      get("/trailheads/new").should route_to("trailheads#new")
    end

    it "routes to #show" do
      get("/trailheads/1").should route_to("trailheads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/trailheads/1/edit").should route_to("trailheads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/trailheads").should route_to("trailheads#create")
    end

    it "routes to #update" do
      put("/trailheads/1").should route_to("trailheads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/trailheads/1").should route_to("trailheads#destroy", :id => "1")
    end

  end
end
