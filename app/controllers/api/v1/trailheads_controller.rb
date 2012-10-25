module Api
  module V1
    class TrailheadsController < Api::V1::ApiController

      caches_action :index, :expires_in => 60, :cache_path => Proc.new { |c| c.params }

      def index
        if params[:non_profit_partner_id]
          partner_id = params[:non_profit_partner_id]
          parks = Park.where(:non_profit_partner_id => partner_id)
          trailhead_ids = parks.collect{|p| p.trailheads }.flatten

          attribute_id = params[:attribute_id]
          if attribute_id
            @trailheads = TrailheadFeature.find(attribute_id).trailheads.where(id:trailhead_ids)
          else
            @trailheads = Trailhead.where(id:trailhead_ids)
          end
          @trailheads = apply_limit_and_offset(params,@trailheads.order('name'))
        else
          @trailheads = apply_limit_and_offset(params,Trailhead.order("id").includes(:cached_park_by_bounds,:park))
        end
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
