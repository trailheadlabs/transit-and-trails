module Api
  module V1
    class UsersController < ApplicationController
      def index
        @users = apply_limit_and_offset(params,User.order("id desc"))
      end

      def show
        @user = User.find(params[:id])
      end
    end
  end
end
