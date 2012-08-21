module Api
  module V1
    class UsersController < ApplicationController
      def index
        @users = User.order("id desc")
      end

      def show
        @user = User.find(params[:id])
      end
    end
  end
end
