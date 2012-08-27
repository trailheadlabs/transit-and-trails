module Api
  module V1
    class CampgroundsController < ApplicationController
      def index
        @campgrounds = apply_limit_and_offset(params, Campground.order("id"))
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
