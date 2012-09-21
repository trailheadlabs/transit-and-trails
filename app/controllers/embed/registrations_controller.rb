module Embed
  class RegistrationsController < ApplicationController
    def new
      @user = User.new
      render :layout => 'static_embed'
    end

    # POST /trailheads
    # POST /trailheads.json
    def create
      @user = User.new(params[:user])
      @user.build_user_profile(signup_source:"bay_nature_trip_editor")
      respond_to do |format|
        if @user.save
          format.html { render "thanks", :layout => "static_embed" }
        else
          format.html { render action: "new", :layout => 'static_embed' }
        end
      end
    end

    def approve
      @user = User.find_by_username(params[:username])
      @user.trailblazer = true
      respond_to do |format|
        if @user.save
          Embed::RegistrationMailer.user_approved_email(@user).deliver
          format.html { render :layout => "static_embed" }
        else
          format.html { render :layout => "static_embed" }
        end
      end
    end

    def confirm
      @user = User.confirm_by_token(params[:confirmation_token])
      if(@user.errors.size < 0)
        Embed::RegistrationMailer.admin_registration_email(@user).deliver
      end
      render :layout => "static_embed"
    end

  end
end
