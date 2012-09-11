class StoriesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show]

  # GET /stories/new
  # GET /stories/new.json
  def new

    @story = Story.new
    if params[:trailhead_id]
      @story.storytellable_id = params[:trailhead_id]
      @story.storytellable_type = "Trailhead"
    elsif params[:campground_id]
      @story.storytellable_id = params[:campground_id]
      @story.storytellable_type = "Trip"
    elsif params[:trip_id]
      @story.storytellable_id = params[:trip_id]
      @story.storytellable_type = "Trip"
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end


  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])
    @story.user = current_user

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story.storytellable, notice: 'Story added!' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { redirect_to :back }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

end

