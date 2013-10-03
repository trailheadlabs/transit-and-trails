module Api
  module V1
    class TripsController < Api::V1::ApiController
      def index
        @trips = apply_limit_and_offset(params,Trip.order("id"))
        if(params[:latitude] && params[:longitude])
          distance = params[:distance] || 100
          @trips = @trips.near([params[:latitude],params[:longitude]],distance)
        end

        if(params[:user_id])
          @trips = @trips.where(user_id:params[:user_id].split(','))
        end

      end

      def show
        @trip = Trip.find(params[:id])
      end

      def photos
        @photos = Trip.find(params[:id]).photos
      end

      def maps
        @maps = Trip.find(params[:id]).maps
      end

      def attributes
        @attributes = Trip.find(params[:id]).trip_features
      end

      def route
        @trip = Trip.find(params[:id])
      end

    end
  end
end
