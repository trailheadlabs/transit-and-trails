class ParksController < ApplicationController

  def show_by_unit_slug
    render_park(parks)
  end

  def show
    if params[:county_slug]
      @parks = Park.where(:slug=>params[:slug],:county_slug=>params[:county_slug])
    elsif params[:slug]   
      @parks = Park.where(:slug=>params[:slug])
      if @parks.empty?
         @parks = Park.where(:id=>params[:slug])
      end
    end

    @polys = []
    @acres = 0
    @agencies = []
    @names = []
    @trips = []
    @tripnames = []
    @trailheads = []
    @trailheadnames = []
    @campgrounds = []
    @campgroundnames = []

    @agencies = @parks.collect{|p| p.agency}.uniq

    @parks.each do |park|
      @acres += park.acres
      @polys += park.polys
      @trips += park.trips
      @campgrounds += park.campgrounds
      @trailheads += park.trailheads
    end

    @trips.uniq!
    @campgrounds.uniq!
    @park = @parks && @parks.first
    respond_to do |format|
      if @park
        format.html # show.html.erb
      else
        not_found
      end
    end
  end

end
