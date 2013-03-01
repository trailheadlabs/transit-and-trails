module Api
  module V1
    class CampgroundAttributesController < Api::V1::ApiController
      def index
        @campground_attributes = apply_limit_and_offset(params,CampgroundFeature.order("id"))
      end
    end
  end
end
