module Embed
  class TripsController < ApplicationController
    before_filter :embed_authenticate_trailblazer!, :except => [:show]

    def new
      @trip = Trip.new
      @trip.intensity = Intensity.first
      @trip.duration = Duration.first
      @trip.name = "My New Trip"
      session[:post_save_redirect] = params[:post_save_redirect]
      render "new", :layout => "static_embed"
    end

    def show
      @trip = Trip.find(params[:id])
      render :layout => "embed"
    end

    def create
      @trip = Trip.new(params[:trip])

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
