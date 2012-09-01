class GeoController < ApplicationController
  def coordinates
    render :text => Geocoder.coordinates(params[:address])
  end

  def distance_between
    render :text => Geocoder::Calculations.distance_between(params[:point_a],params[:point_b])
  end

end
