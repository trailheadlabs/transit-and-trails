module Embed
  class ParksController < ApplicationController
    def show
      if params[:hide_title]
        @hide_title = params[:hide_title] == 'true'
      end

      if params[:county_slug]
        @parks = Park.where(:slug=>params[:slug],:county_slug=>params[:county_slug])
      elsif params[:slug]
        @parks = Park.where(:slug=>params[:slug])
        if @parks.empty?
           @parks = Park.where(:id=>params[:slug])
        end
      elsif params[:id]
          @parks = Park.where(:id=>params[:id])
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
      render :layout => "embed/responsive"

    end
  end
end
