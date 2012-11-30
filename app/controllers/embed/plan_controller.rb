module Embed
  class PlanController < ApplicationController
    caches_action :non_profit_partner_trailheads, :expires_in => 60, :cache_path => Proc.new { |c| c.params }

    def plan
      @initial_date = params[:date]
      @arrive = params[:arrive]
      render "plan", :layout => "embed"
    end

    def location
      @latitude = params[:lat]
      @longitude = params[:lng]
      plan
    end

    def trailhead
      @selected_trailhead = Trailhead.find(params[:trailhead_id])
      plan
    end

    def campground
      @selected_campground = Campground.find(params[:campground_id])
      plan
    end

    def trip
      @selected_trip = Trip.find(params[:trip_id])
      plan
    end

    def trailhead_list
      trailhead_ids = params[:trailhead_ids].split(',')
      @selected_trailheads = Trailhead.where(id: trailhead_ids).order('name')
      plan
    end

    def non_profit_partner_trailheads
      partner_id = params[:partner_id]
      parks = Park.where(:non_profit_partner_id => partner_id)
      trailhead_ids = parks.collect{|p| p.trailheads }.flatten
      trailhead_ids += Trailhead.where(non_profit_partner_id: partner_id)
      attribute_id = params[:attribute_id]
      if attribute_id
        @selected_trailheads = TrailheadFeature.find(attribute_id).trailheads.where(id:trailhead_ids)
      else
        @selected_trailheads = Trailhead.where(id:trailhead_ids)
      end
      @selected_trailheads = @selected_trailheads.order('name')
      plan
    end

  end
end
