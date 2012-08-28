class CampgroundsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show]

  # GET /campgrounds
  # GET /campgrounds.json
  def index
    @campgrounds = Campground.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campgrounds }
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
      format.html { redirect_to campgrounds_url }
      format.json { head :no_content }
    end
  end
end
