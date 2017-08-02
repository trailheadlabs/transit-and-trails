module Api
  module V1
    class TrailheadsController < Api::V1::ApiController

      # caches_action :index, :expires_in => 60, :cache_path => Proc.new { |c| c.params.except(:key) }

      def index
        approved = true
        approved = false if params[:unapproved]
        @trailheads = Trailhead.order("id").includes(:cached_park_by_bounds,:park)
        if params[:non_profit_partner_id]
          partner_id = params[:non_profit_partner_id].split(",")
          parks = Park.where(:non_profit_partner_id => partner_id)
          trailhead_ids = parks.collect{|p| p.trailheads }.flatten
          trailhead_ids += Trailhead.select(:id).where(non_profit_partner_id: partner_id)
          attribute_id = params[:attribute_id]
          if attribute_id
            @trailheads = TrailheadFeature.find(attribute_id).trailheads.where(id:trailhead_ids).order("id")
          else
            @trailheads = Trailhead.where(id:trailhead_ids).order("id")
          end
        else
          if attribute_id = params[:attribute_id]
            trailhead_ids = TrailheadFeature.find(attribute_id).trailheads.pluck(:id)
            @trailheads = Trailhead.where(id:trailhead_ids).order("id")
          end
        end

        if(params[:latitude] && params[:longitude])
          distance = params[:distance] || 100
          if distance < 100
            @trailheads = @trailheads.near([params[:latitude],params[:longitude]],distance)
          end
        end

        if(params[:user_id])
          @trailheads = @trailheads.where(user_id:params[:user_id].split(','))
        end

        if(params[:id])
          @trailheads = @trailheads.where(id:params[:id].split(','))
        end

        @trailheads = apply_limit_and_offset(params,@trailheads.approved.order('id'))

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
