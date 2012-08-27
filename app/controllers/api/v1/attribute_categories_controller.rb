module Api
  module V1
    class AttributeCategoriesController < ApplicationController
      def index
        @attribute_categories = apply_limit_and_offset(params,Category.order("id desc"))
      end

      def show
        @attribute_category = Category.find(params[:id])
      end
    end
  end
end
