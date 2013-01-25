class CampgroundsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show,:near_coordinates,:info_window]

  # GET /campgrounds
  # GET /campgrounds.json
  def index
    redirect_to find_campgrounds_path
  end

  # GET /campgrounds/near_coordinates
  # GET /campgrounds/near_coordinates.json
  def near_coordinates
    latitude = params[:latitude] || 37.7749295
    longitude = params[:longitude] || -122.4194155
    distance = params[:distance] || 10
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @campgrounds = Campground.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campgrounds }
    end
  end

  def info_window
    @point = Campground.find(params[:id])
    @feature_names = @point.campground_features.collect{|f| f.name}.join(",  ")
    respond_to do |format|
      format.html { render :layout => false} # show.html.erb
    end
  end


  # GET /campgrounds/1
  # GET /campgrounds/1.json
  def show
    @campground = Campground.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campground }
    end
  end

  # GET /campgrounds/new
  # GET /campgrounds/new.json
  def new
    @campground = Campground.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campground }
    end
  end

  # GET /campgrounds/1/edit
  def edit
    @campground = Campground.find(params[:id])
  end

  # POST /campgrounds
  # POST /campgrounds.json
  def create
    @campground = Campground.new(params[:campground])
    @campground.user = current_user

    respond_to do |format|
      if @campground.save
        format.html { redirect_to @campground, notice: 'Campground was successfully created.' }
        format.json { render json: @campground, status: :created, location: @campground }
      else
        format.html { render action: "new" }
        format.json { render json: @campground.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /campgrounds/1
  # PUT /campgrounds/1.json
  def update
    @campground = Campground.find(params[:id])

    respond_to do |format|
      if @campground.update_attributes(params[:campground])
        format.html { redirect_to @campground, notice: 'Campground was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @campground.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campgrounds/1
  # DELETE /campgrounds/1.json
  def destroy
    @campground = Campground.find(params[:id])
    @campground.destroy

    respond_to do |format|
      format.html { redirect_to find_campgrounds_url }
      format.json { head :no_content }
    end
  end
end
