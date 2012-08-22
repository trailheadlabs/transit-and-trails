module Api
  module V1
    class AttributeCategoriesController < ApplicationController
      def index
        @attribute_categories = Category.order("id desc")
      end

      def show
        @attribute_category = Category.find(params[:id])
      end
    end
  end
end
