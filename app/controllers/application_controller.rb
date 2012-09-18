class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location

  def find
    store_location
    @latest_photos = Photo.order('id desc').limit(6)
    @featuredtab = FeaturedTab.last
    @recentactivity = RecentActivity.last
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Admin user required."
      redirect_to '/' # halts request cycle
    end
  end

  def apply_limit_and_offset(params,records)
    if params[:limit]
      records = records.limit(Integer(params[:limit]))
    end
    if params[:offset]
      records = records.offset(Integer(params[:offset]))
    end
    return records
  end

  def loadkv
    render :json => {:key=>params[:key],:value=>session[params[:key]] || nil}
  end

  def savekv
    session[params[:key]] = params[:value]
    render :json => {:key=>params[:key],:value=>params[:value]}
  end

  def store_location
    unless params[:controller].match /devise/
      url = request.referrer
      session[:user_return_to] = url
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def objects_near
    latitude = params[:lat]
    longitude = params[:long]
    distance = params[:distance]
    approved = true
    limit = 1000
    offset = 0
    @trailheads = Trailhead.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset).collect do |t|
      t['class_name'] = 'Trailhead'
      t
    end
    @campgrounds = Campground.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset).collect do |c|
      c['class_name'] = 'Campground'
      c
    end
    # trip_ids = Trailhead.where(:approved => approved).near([latitude,longitude],distance,:select => "trailheads.*, trips.*").joins(:trips_starting_at).limit(limit).offset(offset).collect(&:id)
    @trips = Trailhead.where(:approved => approved).near([latitude,longitude],distance,:select => "trailheads.*, trips.*").joins(:trips_starting_at).limit(limit).offset(offset).collect do |t|
      t['class_name'] = 'Trip'
      t
    end
    @allpoints = @trailheads + @campgrounds + @trips
    @allpoints.sort! { |a,b| Float(a.distance) <=> Float(b.distance) }
    render :layout => false
  end
end
