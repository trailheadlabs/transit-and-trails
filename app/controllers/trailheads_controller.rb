class TrailheadsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show,:near_address,:near_coordinates]

  # GET /trailheads
  # GET /trailheads.json
  def index
    @trailheads = Trailhead.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads
  # GET /trailheads.json
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

  # GET /trailheads
  # GET /trailheads.json
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

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
    @trailhead = Trailhead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trailhead }
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
