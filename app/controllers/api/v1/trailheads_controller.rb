module Api
  module V1
    class TrailheadsController < ApplicationController
      def index
        @trailheads = apply_limit_and_offset(params,Trailhead.order("id")).includes(:cached_park_by_bounds)
      end

      def show
        @trailhead = Trailhead.find(params[:id])
      end

      def photos
        @photos = Trailhead.find(params[:id]).photos
      end

      def maps
        @maps = Trailhead.find(params[:id]).maps
      end

      def attributes
        @attributes = Trailhead.find(params[:id]).trailhead_features
      end

    end
  end
end
