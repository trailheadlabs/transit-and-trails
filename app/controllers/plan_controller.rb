class PlanController < ApplicationController

  def trailhead
    @trailhead = Trailhead.find(params[:trailhead_id])
    render "plan"
  end

  def trip
    # if true
    if request.subdomain == 'embed'
      redirect_to "/embed" + request.path
    else
      @trip = Trip.find(params[:trip_id])
      render "plan"
    end
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
