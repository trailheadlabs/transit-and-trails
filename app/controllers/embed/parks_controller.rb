module Embed
  class ParksController < ApplicationController
    def show
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

      Rails.logger.info("agencies started")
      @agencies = @parks.collect{|p| p.agency}.uniq
      Rails.logger.info("agencies finished")

      @parks.each do |park|
        @acres += park.acres
        Rails.logger.info("polys started #{DateTime.now.to_f}")
        @polys += park.polys
        Rails.logger.info("polys finished #{DateTime.now.to_f}")
        Rails.logger.info("trips started #{DateTime.now.to_f}")
        @trips += park.trips
        Rails.logger.info("trips finished #{DateTime.now.to_f}")
        Rails.logger.info("campgrounds started #{DateTime.now.to_f}")
        @campgrounds += park.campgrounds
        Rails.logger.info("campgrounds finished #{DateTime.now.to_f}")
        Rails.logger.info("trailheads started #{DateTime.now.to_f}")
        @trailheads += park.trailheads
        Rails.logger.info("trailheads finished #{DateTime.now.to_f}")
      end

      @trips.uniq!
      @campgrounds.uniq!
      @park = @parks && @parks.first
      render :layout => "embed/responsive"

    end
  end
end
