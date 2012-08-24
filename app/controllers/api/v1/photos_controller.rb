module Api
  module V1
    class PhotosController < ApplicationController
      def index
        if params[:trailhead_id]
          @photos = Trailhead.find(params[:trailhead_id]).photos
        else
          @photos = Photo.order("id desc")
        end
      end

      def show
        @photo = Photo.find(params[:id])
      end
    end
  end
end
