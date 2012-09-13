class PlanController < ApplicationController
  def trailhead
    @trailhead = Trailhead.find(params[:trailhead_id])
    render "plan"
  end

  def trip
    @trip = Trip.find(params[:trip_id])
    render "plan"
  end

  def campground
    @campground = Campground.find(params[:campground_id])
    render "plan"
  end

  def coordinates
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    render "plan"
  end

end
