module Api
  module V1
    class TripsController < Api::V1::ApiController
      caches_action :index, :expires_in => 60, :cache_path => Proc.new { |c| c.params.except(:key) }
      def index
        @trips = apply_limit_and_offset(params,Trip.order("id"))
        if(params[:latitude] && params[:longitude])
          distance = params[:distance] || 100
          @trips = @trips.near([params[:latitude],params[:longitude]],distance)
        end

        if(params[:user_id])
          @trips = @trips.where(user_id:params[:user_id].split(','))
        end

        if(params[:id])
          @trips = @trips.where(id:params[:id].split(','))
        end

        attribute_id = params[:attribute_id]
        if attribute_id
          trip_ids = TripFeature.find(attribute_id).trips.pluck(:id)          
          @trips = @trips.where(id:trip_ids).order("id")
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
