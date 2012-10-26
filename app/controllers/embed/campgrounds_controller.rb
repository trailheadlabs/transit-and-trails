module Embed
  class CampgroundsController < ApplicationController
    def details
      @campground = Campground.find(params[:id])
      render "details", :layout => "embed"
    end
  end
end
