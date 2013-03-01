module Api
  module V1
    class TrailheadAttributesController < Api::V1::ApiController
      def index
        @trailhead_attributes = apply_limit_and_offset(params,TrailheadFeature.order("id"))
      end
    end
  end
end
