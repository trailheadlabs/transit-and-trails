module Api
  module V1
    class TripAttributesController < Api::V1::ApiController
      def index
        @trip_attributes = apply_limit_and_offset(params,TripFeature.order("id"))
      end
    end
  end
end
