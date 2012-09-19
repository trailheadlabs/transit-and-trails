module Api
  module V1
    class CampgroundsController < ApplicationController

      caches_action :index, :expires_in => 60

      def index
        @campgrounds = apply_limit_and_offset(params, Campground.order("id").includes(:cached_park_by_bounds,:park))
      end

      def show
        @campground = Campground.find(params[:id])
      end

      def photos
        @photos = Campground.find(params[:id]).photos
      end

      def maps
        @maps = Campground.find(params[:id]).maps
      end

      def attributes
        @attributes = Campground.find(params[:id]).campground_features
      end

    end
  end
end
