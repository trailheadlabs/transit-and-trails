module Embed
  class TripsController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_filter :embed_authenticate_trailblazer!, :except => [:show,:map]

    def new
      @trip = Trip.new
      @trip.intensity = Intensity.first
      @trip.duration = Duration.first
      @trip.name = "My New Trip"
      @center_latitude = params[:center_latitude]
      @center_longitude = params[:center_longitude]

      session[:post_save_redirect] = params[:post_save_redirect]
      render "new", :layout => "static_embed"
    end

    def show
      @trip = Trip.find(params[:id])

      if params[:show]
        @show = params[:show].split(',')
      else
        @show = ['trails','description','contributor','summary','photos','map','attributes','actions','header','downloads','branding']
      end

      if params[:hide]
        @hide = params[:hide].split(',')
        @show = @show - @hide
      end

      if params[:hide_title]
        @hide_title = params[:hide_title] == 'true'
      end

      if params[:hide_section_labels]
        @hide_section_labels = params[:hide_section_labels] == 'true'
      end

      if params[:full_description]
        @full_description = params[:full_description] == 'true'
      end

      render :layout => "embed/responsive"
    end

    def map
      @trip = Trip.find(params[:id])
      render :layout => "embed/fill"
    end

    def create
      @trip = Trip.new(params[:trip])
      @trip.user = current_user

      respond_to do |format|
        if @trip.save
          format.html { redirect_to edit_details_embed_trip_path(@trip) }
        else
          format.html { render action: "new", :layout=>"static_embed" }
        end
      end
    end

    def update
      @trip = Trip.find(params[:id])

      respond_to do |format|
        if @trip.update_attributes(params[:trip])
          format.html { redirect_to edit_details_embed_trip_path(@trip) }
        else
          format.html { render action: "new", :layout=>"static_embed" }
        end
      end
    end

    def edit
      session[:post_save_redirect] = params[:post_save_redirect]
      @trip = Trip.find(params[:id])
      render :layout => "static_embed"
    end

    def edit_details
      @trip = Trip.find(params[:id])
      render :layout => "static_embed"
    end


    # PUT /trips/1
    # PUT /trips/1.json
    def update_details
      @trip = Trip.find(params[:id])

      respond_to do |format|
        if @trip.update_attributes(params[:trip])
          format.html { redirect_to edit_photos_embed_trip_path @trip }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @trip.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit_photos
      @trip = Trip.find(params[:id])
      @post_save_redirect = session[:post_save_redirect] ? session[:post_save_redirect] + "?trip_id=#{@trip.id}" : edit_embed_trip_path(@trip)

      render :layout => "static_embed"
    end

  end
end
