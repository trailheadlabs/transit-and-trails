class TrailheadsController < ApplicationController
  check_authorization :except => [:near_address,:near_coordinates,:index,:info_window]
  load_and_authorize_resource :except => [:near_address,:near_coordinates,:index,:info_window]
  before_filter :authenticate_user!, :except => [:index,:show,:near_address,:near_coordinates,:within_bounds,:info_window]

  # GET /trailheads/near_address
  # GET /trailheads/near_address.json
  def near_address
    address = params[:address] || "San Francisco, CA"
    distance = params[:distance] || 10
    limit = 20 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where(:approved => approved).near(address,distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads/near_coordinates
  # GET /trailheads/near_coordinates.json
  def near_coordinates
    latitude = params[:latitude] || 37.7749295
    longitude = params[:longitude] || -122.4194155
    distance = params[:distance] || 10
    limit = 20 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads/within_bounds
  # GET /trailheads/within_bounds.json
  def within_bounds
    min_latitude = params[:sw_latitude]
    max_latitude = params[:ne_latitude]
    min_longitude = params[:sw_longitude]
    max_longitude = params[:sw_longitude]
    limit = 20 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => min_latitude, :min_longitude => min_longitude, :max_latitude => max_latitude, :max_longitude => max_longitude)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    if(params[:park_id])
      @trailheads = Park.find(params[:park_id]).trailheads
    else
      @trailheads = Trailhead.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
    @trailhead = Trailhead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trailhead }
    end
  end

  def info_window
    @point = Trailhead.find(params[:id])
    @trips = Trip.where(:starting_trailhead_id=>@point.id)
    @feature_names = @point.trailhead_features.collect{|f| f.name}.join(",  ")
    respond_to do |format|
      format.html { render :layout => false} # show.html.erb
    end
  end

  # GET /trailheads/new
  # GET /trailheads/new.json
  def new
    @trailhead = Trailhead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trailhead }
    end
  end

  # GET /trailheads/1/edit
  def edit
    @trailhead = Trailhead.find(params[:id])
  end

  # POST /trailheads
  # POST /trailheads.json
  def create
    @trailhead = Trailhead.new(params[:trailhead])

    respond_to do |format|
      if @trailhead.save
        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully created.' }
        format.json { render json: @trailhead, status: :created, location: @trailhead }
      else
        format.html { render action: "new" }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trailheads/1
  # PUT /trailheads/1.json
  def update
    @trailhead = Trailhead.find(params[:id])

    respond_to do |format|
      if @trailhead.update_attributes(params[:trailhead])
        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trailheads/1
  # DELETE /trailheads/1.json
  def destroy
    @trailhead = Trailhead.find(params[:id])
    @trailhead.destroy

    respond_to do |format|
      format.html { redirect_to trailheads_url }
      format.json { head :no_content }
    end
  end
end
