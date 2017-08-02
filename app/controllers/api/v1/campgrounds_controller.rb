module Api
  module V1
    class CampgroundsController < Api::V1::ApiController

      caches_action :index, :expires_in => 60, :cache_path => Proc.new { |c| c.params.except(:key) }

      def index
        @campgrounds = Campground.order("id").includes(:cached_park_by_bounds,:park)
        if params[:non_profit_partner_id]
          partner_id = params[:non_profit_partner_id]
          parks = Park.where(:non_profit_partner_id => partner_id)
          campground_ids = parks.collect{|p| p.campgrounds }.flatten

          attribute_id = params[:attribute_id]
          if attribute_id
            @campgrounds = CampgroundFeature.find(attribute_id).campgrounds.where(id:campground_ids).order("id")
          else
            @campgrounds = Campground.where(id:campground_ids).order("id")
          end
        end

        if(params[:latitude] && params[:longitude])
          distance = params[:distance] || 100
          if distance < 100
            @campgrounds = @campgrounds.near([params[:latitude],params[:longitude]],distance)
          end
        end

        if(params[:user_id])
          @campgrounds = @campgrounds.where(user_id:params[:user_id].split(','))
        end


        @campgrounds = apply_limit_and_offset(params,@campgrounds.order('id'))
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
