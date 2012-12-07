class FindController < ApplicationController
  def trips
    render :layout => "v2"
  end

  def trailheads
    render :layout => "v2"
  end

  def campgrounds
    render :layout => "v2"
  end

  def find
    @latest_photos = Photo.order('legacy_id desc, id desc').limit(6)
    @featuredtab = FeaturedTab.last
    @recentactivity = RecentActivity.last
  end

  def trailheads_within_bounds
    sw_latitude = Float(params[:sw_latitude])
    ne_latitude = Float(params[:ne_latitude])
    sw_longitude = Float(params[:sw_longitude])
    ne_longitude = Float(params[:ne_longitude])
    center_latitude = Float(params[:center_latitude])
    center_longitude = Float(params[:center_longitude])
    limit = 100 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    @filter_names = []
    if(params[:feature_ids])
      ids = params[:feature_ids]
      @trailheads = @trailheads.find(:all,:include=>:trailhead_features,:conditions=>['trailhead_features.id IN (?)',ids])
      @filter_names += TrailheadFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:my_trailheads])
      @trailheads = @trailheads.where(user_id: current_user)
      @filter_names += ["My Trailheads"]
    end

    unless(params[:near].blank?)
      @filter_names += ["Near: #{params[:near]}"]
    end

    unless(params[:user_query].blank?)
      q = "%#{params[:user_query]}%"
      @users = User.where("username ILIKE ?",q)
      @trailheads = @trailheads.where(user_id: @users)
      @filter_names += ["User: #{params[:user_query]}"]
    end

    unless(params[:name_query].blank?)
      q = "%#{params[:name_query]}%"
      @trailheads = @trailheads.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end

    @trailheads = Trailhead.where(approved: approved, id: @trailheads).limit(limit).offset(offset).near([center_latitude,center_longitude])
    render :partial => "trailheads_within_bounds", :locals => {:trailheads => @trailheads, :filter_names => @filter_names}
  end

  def campgrounds_within_bounds
    sw_latitude = Float(params[:sw_latitude])
    ne_latitude = Float(params[:ne_latitude])
    sw_longitude = Float(params[:sw_longitude])
    ne_longitude = Float(params[:ne_longitude])
    center_latitude = Float(params[:center_latitude])
    center_longitude = Float(params[:center_longitude])
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @campgrounds = Campground.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    @filter_names = []
    if(params[:feature_ids])
      ids = params[:feature_ids]
      @campgrounds = @campgrounds.find(:all,:include=>:campground_features,:conditions=>['campground_features.id IN (?)',ids])
      @filter_names += CampgroundFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:my_campgrounds])
      @campgrounds = @campgrounds.where(user_id: current_user)
      @filter_names += ["My Campgrounds"]
    end

    unless(params[:near].blank?)
      @filter_names += ["Near: #{params[:near]}"]
    end

    unless(params[:user_query].blank?)
      q = "%#{params[:user_query]}%"
      @users = User.where("username ILIKE ?",q)
      @campgrounds = @campgrounds.where(user_id: @users)
      @filter_names += ["User: #{params[:user_query]}"]
    end

    unless(params[:name_query].blank?)
      q = "%#{params[:name_query]}%"
      @campgrounds = @campgrounds.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end

    @campgrounds = Campground.where(approved: approved, id: @campgrounds).limit(limit).offset(offset).near([center_latitude,center_longitude])
    render :partial => "campgrounds_within_bounds", :locals => {:campgrounds => @campgrounds, :filter_names => @filter_names}
  end

  def trips_within_bounds
    sw_latitude = Float(params[:sw_latitude])
    ne_latitude = Float(params[:ne_latitude])
    sw_longitude = Float(params[:sw_longitude])
    ne_longitude = Float(params[:ne_longitude])
    center_latitude = Float(params[:center_latitude])
    center_longitude = Float(params[:center_longitude])
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @filter_names = []
    @trips = Trip.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)

    if(params[:feature_ids])
      ids = params[:feature_ids]
      @trips = @trips.find(:all,:include=>:trip_features,:conditions=>['trip_features.id IN (?)',ids])
      @filter_names += TripFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:duration_ids])
      @trips = @trips.where(duration_id: params[:duration_ids])
      @filter_names += Duration.find(params[:duration_ids]).collect(&:name)
    end

    if(params[:intensity_ids])
      @trips = @trips.where(intensity_id: params[:intensity_ids])
      @filter_names += Intensity.find(params[:intensity_ids]).collect(&:name)
    end

    if(params[:my_trips])
      @trips = @trips.where(user_id: current_user)
      @filter_names += ["My Trips"]
    end

    unless(params[:near].blank?)
      @filter_names += ["Near: #{params[:near]}"]
    end

    unless(params[:user_query].blank?)
      q = "%#{params[:user_query]}%"
      @users = User.where("username ILIKE ?",q)
      @trips = @trips.where(user_id: @users)
      @filter_names += ["User: #{params[:user_query]}"]
    end

    unless(params[:name_query].blank?)
      q = "%#{params[:name_query]}%"
      @trips = @trips.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end

    @trips = Trip.where(approved: approved, id: @trips).limit(limit).offset(offset).near([center_latitude,center_longitude])
    render :partial => "trips_within_bounds", :locals => {:trips => @trips, :filter_names => @filter_names}
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
