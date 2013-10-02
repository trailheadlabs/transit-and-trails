class FindController < ApplicationController
  def trips
  end

  def trailheads
  end

  def campgrounds
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
    session[:starting_lat] = center_latitude = Float(params[:center_latitude])
    session[:starting_lng] = center_longitude = Float(params[:center_longitude])
    session[:starting_zoom] = zoom = Float(params[:zoom])
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @filter_names = []

    if(params[:name_query].blank?)
      @trailheads = Trailhead.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    else
      q = "%#{params[:name_query]}%"
      @trailheads = Trailhead.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end

    if(params[:feature_ids])
      ids = params[:feature_ids]
      @trailheads = @trailheads.joins(:trailhead_features).where(:trailhead_features => {:id => ids}).group('trailheads.id').having(['count(trailheads.id) = ?',ids.length])
      @filter_names += TrailheadFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:unapproved])
      cookies[:unapproved] = true
      approved = false
      @filter_names += ["Unapproved"]
    else
      cookies.delete :unapproved
    end

    if(params[:only_mine])
      cookies[:only_mine] = true
      @trailheads = @trailheads.where(user_id: current_user)
      @filter_names += ["Only Mine"]
    else
      cookies.delete :only_mine
    end

    @near = "#{params[:near]}" || "San Francisco, CA"

    unless(params[:user_query].blank?)
      q = "%#{params[:user_query]}%"
      @users = User.where("username ILIKE ?",q)
      @trailheads = @trailheads.where(user_id: @users)
      @filter_names += ["User: #{params[:user_query]}"]
    end


    @trailheads = Trailhead.where(approved: approved, id: @trailheads).near([center_latitude,center_longitude])
    @trailheads = @trailheads.page params[:page]
    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.js # show.html.erb
      format.json { render json: @trailhead }
    end
  end

  def campgrounds_within_bounds
    sw_latitude = Float(params[:sw_latitude])
    ne_latitude = Float(params[:ne_latitude])
    sw_longitude = Float(params[:sw_longitude])
    ne_longitude = Float(params[:ne_longitude])
    session[:starting_lat] = center_latitude = Float(params[:center_latitude])
    session[:starting_lng] = center_longitude = Float(params[:center_longitude])
    session[:starting_zoom] = zoom = Float(params[:zoom])
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @filter_names = []
    if(params[:name_query].blank?)
      @campgrounds = Campground.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    else
      q = "%#{params[:name_query]}%"
      @campgrounds = Campground.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end

    if(params[:feature_ids])
      ids = params[:feature_ids]
      @campgrounds = @campgrounds.joins(:campground_features).where(:campground_features => {:id => ids}).group('campgrounds.id').having(['count(campgrounds.id) = ?',ids.length])
      @filter_names += CampgroundFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:unapproved])
      cookies[:unapproved] = true
      approved = false
      @filter_names += ["Unapproved"]
    else
      cookies.delete :unapproved
    end

    if(params[:only_mine])
      cookies[:only_mine] = true
      @campgrounds = @campgrounds.where(user_id: current_user)
      @filter_names += ["Only Mine"]
    else
      cookies.delete :only_mine
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

    @campgrounds = Campground.where(approved: approved, id: @campgrounds).limit(limit).offset(offset).near([center_latitude,center_longitude])
    @campgrounds = @campgrounds.page params[:page]
    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.js # show.html.erb
      format.json { render json: @trailhead }
    end

  end

  def trips_within_bounds
    sw_latitude = Float(params[:sw_latitude])
    ne_latitude = Float(params[:ne_latitude])
    sw_longitude = Float(params[:sw_longitude])
    ne_longitude = Float(params[:ne_longitude])
    session[:starting_lat] = center_latitude = Float(params[:center_latitude])
    session[:starting_lng] = center_longitude = Float(params[:center_longitude])
    session[:starting_zoom] = zoom = Float(params[:zoom])
    approved = true || params[:approved]
    @filter_names = []
    if(params[:name_query].blank?)
      @trips = Trip.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    else
      q = "%#{params[:name_query]}%"
      @trips = Trip.where("name ILIKE ?",q)
      @filter_names += ["Name: #{params[:name_query]}"]
    end


    @near = params[:near].blank? ? "San Francisco, CA" : "#{params[:near]}"

    if(params[:duration_ids])
      @trips = @trips.where(duration_id: params[:duration_ids])
      @filter_names += Duration.find(params[:duration_ids]).collect(&:name)
    end

    if(params[:intensity_ids])
      @trips = @trips.where(intensity_id: params[:intensity_ids])
      @filter_names += Intensity.find(params[:intensity_ids]).collect(&:name)
    end

    if(params[:feature_ids])
      ids = params[:feature_ids]
      @trips = @trips.joins(:trip_features).where(:trip_features => {:id => ids}).group('trips.id').having(['count(trips.id) = ?',ids.length])
      @filter_names += TripFeature.find(params[:feature_ids]).collect(&:name)
    end

    if(params[:unapproved])
      cookies[:unapproved] = true
      approved = false
      @filter_names += ["Unapproved"]
    else
      cookies.delete :unapproved
    end

    if(params[:only_mine])
      cookies[:only_mine] = true
      @trips = @trips.where(user_id: current_user)
      @filter_names += ["Only Mine"]
    else
      cookies.delete :only_mine
    end

    unless(params[:user_query].blank?)
      q = "%#{params[:user_query]}%"
      @users = User.where("username ILIKE ?",q)
      @trips = @trips.where(user_id: @users)
      @filter_names += ["User: #{params[:user_query]}"]
    end

    @trips = Trip.where(approved: approved, id: @trips).near([center_latitude,center_longitude])
    @trips = @trips.page params[:page]
    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.js # show.html.erb
      format.json { render json: @trailhead }
    end

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
    session[:starting_lat] = @starting_lat = 37.904141
    session[:starting_lng] = @starting_lng = -122.603838
    render "trips"
  end

  def sanjosetrails
    self.find
    session[:starting_lat] = @starting_lat = 37.3393857
    session[:starting_lng] = @starting_lng = -121.8949555
    render "trips"
  end

  def regional_landing_page
    self.find
    object = RegionalLandingPage.find_by_path(params[:region])
    if object.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
    session[:starting_lat] = @starting_lat = object.latitude
    session[:starting_lng] = @starting_lng = object.longitude
    render "trips"
  end
end
