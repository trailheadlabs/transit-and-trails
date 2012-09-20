module Embed
  class TripsController < ApplicationController
    before_filter :embed_authenticate_user!
    def new
      @trip = Trip.new
      render "new", :layout => "static_embed"
    end
  end
end
