class TripsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show,:info_window,:near_coordinates]
  check_authorization :only => [:new,:edit]
  load_and_authorize_resource :only => [:new,:edit]

  # GET /trips
  # GET /trips.json
  def index
    redirect_to find_trips_path
  end

  # GET /trips/near_coordinates
  # GET /trips/near_coordinates.json
  def near_coordinates
    latitude = params[:latitude] || 37.7749295
    longitude = params[:longitude] || -122.4194155
    distance = params[:distance] || 10
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trips = Trip.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    if request.subdomain == 'embed'
      redirect_to "/embed" + request.path
      return
    end

    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        @trip['start_lat'] = @trip.starting_trailhead.latitude
        @trip['start_lng'] = @trip.starting_trailhead.longitude
        @trip['end_lat'] = @trip.ending_trailhead.latitude
        @trip['end_lng'] = @trip.ending_trailhead.longitude
       render json: @trip
      end
    end
  end

  def info_window
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new
    @trip.approved = true
    @trip.intensity = Intensity.first
    @trip.duration = Duration.first
    @start_id = params[:start_id]
    @center_latitude = params[:center_latitude]
    @center_longitude = params[:center_longitude]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])
    @trip.user = current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to find_trips_url }
      format.json { head :no_content }
    end
  end
end
