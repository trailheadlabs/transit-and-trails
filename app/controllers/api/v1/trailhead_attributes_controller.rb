module Api
  module V1
    class TrailheadAttributesController < ApplicationController
      def index
        @trailhead_attributes = TrailheadFeature.order("id desc")
      end

      def show
        @trailhead_attribute = TrailheadFeature.find(params[:id])
      end
    end
  end
end
