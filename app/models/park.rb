class Park < ActiveRecord::Base
  belongs_to :agency, :inverse_of => :parks, :touch => true
  has_many :users, :through => :agency
  belongs_to :non_profit_partner, :inverse_of => :parks
  attr_accessible :acres, :bounds, :county, :county_slug, :description, :name, :slug, :link,
    :min_longitude, :max_longitude, :min_latitude, :max_latitude, :non_profit_partner_id, :agency_id, :trailhead_ids
  before_save :update_bounds_min_max
  # after_save :update_cached_points
  has_many :trailhead_overrides, :class_name => 'Trailhead', :inverse_of => :park

  has_paper_trail

  def update_bounds_min_max
    if !bounds.blank? && (self.bounds_changed? || min_longitude.nil?)
      sides = sides_of_bounds
      self.min_longitude = sides[0]
      self.max_longitude = sides[1]
      self.min_latitude = sides[2]
      self.max_latitude = sides[3]
    end
  end

  def cached_trailheads
    Trailhead.approved.where(cached_park_by_bounds_id: id)
  end

  def update_cached_trailheads
    trailheads_in_bounds.each do |t|
      t.update_attributes(cached_park_by_bounds_id: id)
    end
  end

  def trailheads
    ths = cached_trailheads
    overrides = trailhead_overrides.approved
    if users.any?
      overrides = overrides.where(user_id:users)
    end
    ths | overrides
  end

  def trailheads_in_bounds
    trailheads = Trailhead.approved.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => self.min_latitude, :min_longitude => self.min_longitude, :max_latitude => self.max_latitude,
        :max_longitude => self.max_longitude )

    if(users.any?)
      trailheads = trailheads.where(user_id:users)
    end

    trailheads.select! do |t|
      self.contains_trailhead? t
    end
    return trailheads
  end

  def cached_campgrounds
    Campground.approved.where(cached_park_by_bounds_id: id)
  end

  def campgrounds
    result = campgrounds_in_bounds
    if users.any?
      result = result.where(user_id:users)
    end
    result
  end

  def campgrounds_in_bounds
    campgrounds = Campground.approved.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => self.min_latitude, :min_longitude => self.min_longitude, :max_latitude => self.max_latitude,
        :max_longitude => self.max_longitude )

    if(users.any?)
      campgrounds = campgrounds.where(user_id:users)
    end

    campgrounds.select! do |t|
      self.contains_trailhead? t
    end
    return campgrounds
  end

  def update_cached_points
    puts "Updating cached points for #{self.id}"
    Park.transaction do
      trailheads_in_bounds.each do |t|
        t.update_attributes(cached_park_by_bounds_id:self.id)
      end
      campgrounds_in_bounds.each do |t|
        t.update_attributes(cached_park_by_bounds_id:self.id)
      end
    end
  end

  def trips
    if users.any?
      ths = trailheads.collect{|t| t.trips_starting_at.approved.where(user_id:users) + t.trips_ending_at.approved.where(user_id:users) }.flatten
      ids = ths.collect{|t|t.id}
      Trip.where(approved:true,id:ids,user_id:users)
    else
      trailheads.collect{|t| t.trips_starting_at.approved + t.trips_ending_at.approved }.flatten
    end
  end

  def trips_starting_in_bounds
    trips = Trip.where(:starting_trailhead_id => trailheads).approved
    trips.select! do |t|
      self.contains_trailhead? t.starting_trailhead
    end
    return trips
  end

  def trips_ending_in_bounds
    trips = Trip.where(:ending_trailhead_id => trailheads).approved
    trips.select! do |t|
      self.contains_trailhead? t.ending_trailhead
    end
    return trips
  end

  def bounds_as_array
    self.bounds.gsub(/[A-Za-z]|\(|\)/,"").strip.split(',').collect{|c| c.split(" ").collect{|d| Float(d)}}
  end

  def sides_of_bounds
    sides_of_poly bounds_as_array
  end

  def sides_of_poly(poly)
    longs = poly.collect{|c| c[0]}.sort
    lats = poly.collect{|c| c[1]}.sort
    min_long = longs[0]
    max_long = longs[-1]
    min_lat = lats[0]
    max_lat = lats[-1]
    [min_long,max_long,min_lat,max_lat]
  end

  def polys
    if !bounds.blank?
      tmp = bounds.gsub(/[A-Za-z]|\)/,"").strip.split('(').select{|c| !c.blank?}
      tmp.collect!{ |c|c.strip.split(',').collect{|e| e.split(" ").collect{|d| Float(d)}} }
      return tmp
    else
      return []
    end
  end

  def contains_trailhead?(trailhead)
    result = false
    polys.select! do |p|
      sides = sides_of_poly(p)
      trailhead.latitude > sides[2] && trailhead.latitude < sides[3] &&
        trailhead.longitude > sides[0] && trailhead.longitude < sides[1]
    end
    polys.each do |p|
      if contains_point?(p,[trailhead.longitude,trailhead.latitude])
        result = true
        break
      end
    end
    return result
  end

  def intersects_trip?(trip)
    result = false
    4.downto(4).each do |step|
      if result
        break
      end
      # puts "step = #{step}"
      trip.bounds_as_array.each_with_index do |point,index|
        if result
          break
        end
        if index % step == 0
          # puts "index = #{index}"
          if contains_coordinate?(point[1],point[0])
            result = true
            # puts "FOUND!"
            break
          end
        end
      end
    end
    return result
  end

  def contains_coordinate?(latitude, longitude)
    result = false
    polys.each do |p|
      if polygon_bounds_point?(p,[longitude,latitude]) && contains_point?(p,[longitude,latitude])
        result = true
      end
    end
    return result
  end

  def polygon_bounds_point?(polygon,point)
    lats = polygon.collect{|p|p[1]}.sort
    @min_lat ||= lats[0]
    @max_lat ||= lats[-1]
    longs = polygon.collect{|p|p[0]}.sort
    @min_long = longs[0]
    @max_long = longs[-1]
    (point[0] > @min_long && point[0] < @max_long) && (point[1] > @min_lat && point[0] < @max_lat)
  end

  def contains_point?(polygon, point)
    contains_point = false
    i = -1
    j = polygon.size - 1
    while (i += 1) < polygon.size
      a_point_on_polygon = polygon[i]
      trailing_point_on_polygon = polygon[j]
      if point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
        if ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
          contains_point = !contains_point
        end
      end
      j = i
    end
    return contains_point
  end

  def point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (a_point_on_polygon[1] <= point[1] && point[1] < trailing_point_on_polygon[1]) ||
      (trailing_point_on_polygon[1] <= point[1] && point[1] < a_point_on_polygon[1])
  end

  def ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (point[0] < (trailing_point_on_polygon[0] - a_point_on_polygon[0]) * (point[1] - a_point_on_polygon[1]) /
     (trailing_point_on_polygon[1] - a_point_on_polygon[1]) + a_point_on_polygon[0])
  end
end
