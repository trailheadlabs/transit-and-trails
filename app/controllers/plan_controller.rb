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
    @trip = Trip.find(params[:campground_id])
    render "plan"
  end

  def coordinates
    @latitude = Trip.find(params[:latitude])
    @longitude = Trip.find(params[:longitude])
    render "plan"
  end

end
