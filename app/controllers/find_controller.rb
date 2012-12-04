class FindController < ApplicationController
  def v2
    find
    render "v2", :layout => "v2"
  end

  def find
    @latest_photos = Photo.order('legacy_id desc, id desc').limit(6)
    @featuredtab = FeaturedTab.last
    @recentactivity = RecentActivity.last
  end

  def objects_near
    latitude = params[:lat]
    longitude = params[:long]
    distance = params[:distance]
    approved = true
    limit = 1000
    offset = 0
    @trailheads = Trailhead.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    @campgrounds = Campground.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    @trips = Trip.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)

    if(params[:user_id])
      @trailheads = @trailheads.where(user_id: params[:user_id])
      @trips = @trips.where(user_id: params[:user_id])
      @campgrounds = @campgrounds.where(user_id: params[:user_id])
    end

    @allpoints = @trailheads + @campgrounds + @trips
    @allpoints.sort! { |a,b| Float(a.distance) <=> Float(b.distance) }
    render :layout => false
  end

  def marinstage
    self.find
    @starting_lat = 37.904141
    @starting_lng = -122.603838
    render "find"
  end

  def sanjosetrails
    self.find
    @starting_lat = 37.3393857
    @starting_lng = -121.8949555
    render "find"
  end

  def regional_landing_page
    self.find
    object = RegionalLandingPage.find_by_path(params[:region])
    if object.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
    @starting_lat = object.latitude
    @starting_lng = object.longitude
    render "find"
  end
end
