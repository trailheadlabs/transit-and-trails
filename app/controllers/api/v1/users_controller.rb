module Api
  module V1
    class UsersController < Api::V1::ApiController
      def index
        @users = apply_limit_and_offset(params,User.order("id desc"))
      end

      def show
        @user = User.find(params[:id])
      end

      def register
      end

      def login
      end
    end
  end
end
