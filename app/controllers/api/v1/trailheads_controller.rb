module Api
  module V1
    class TrailheadsController < ApplicationController
      def index
        @trailheads = Trailhead.order("id desc")
      end

      def show
        @trailhead = Trailhead.find(params[:id])
      end
    end
  end
end
