class Trip < ActiveRecord::Base
  belongs_to :user
  belongs_to :intensity
  belongs_to :duration
  belongs_to :ending_trailhead, :class_name => "Trailhead", :foreign_key => "ending_trailhead_id"
  belongs_to :starting_trailhead, :class_name => "Trailhead", :foreign_key => "starting_trailhead_id"
  has_and_belongs_to_many :trip_features
  has_many :stories, :as => :storytellable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  has_many :maps, :as => :mapable, :dependent => :destroy
  has_paper_trail
  attr_accessible :approved,
                  :description,
                  :ending_trailhead_id,
                  :name,
                  :route,
                  :starting_trailhead_id,
                  :latitude,
                  :longitude,
                  :intensity_id,
                  :duration_id,
                  :trip_feature_ids,
                  :user_id,
                  :alerts

  before_save :update_bounds_min_max, :update_geometry, :update_coordinates
  after_save :touch_parks

  validates :name, :presence => true, :uniqueness => true

  validates :ending_trailhead_id, :presence => true
  validates :starting_trailhead_id, :presence => true

  reverse_geocoded_by :latitude, :longitude

  scope :approved, where(approved: true)

  def update_coordinates
    if(!starting_trailhead_id.blank? && !starting_trailhead.nil?)
      self.latitude = starting_trailhead.latitude
      self.longitude = starting_trailhead.longitude
    end
  end

  def update_geometry
    if(route_changed?)
      self.geometry = route_as_geometry
    end
  end

  def parks
    @parks ||= find_parks
  end

  def touch_parks
    parks.each do |p|
      p.touch
    end
  end

  def refind_parks
    if(route_changed?)
      Rails.cache.delete("trip:#{id}:park_ids")
      find_parks
    end
    parks.each do |p|
      p.touch
    end    
  end

  def find_parks
    cached_ids = Rails.cache.read("trip:#{id}:park_ids")
    if(cached_ids)
      @parks = Park.where(:id=>cached_ids)
    else
      # is left = min_longitude < park.max_longitude
      # is right = max_longitude > park.min_longitude
      # is above = max_latiude > park.min_latitude
      # is below = min_latitude < park.max_latitude
      @parks = Park.where("max_longitude > :min_longitude AND min_longitude < :max_longitude" +
                          " AND min_latitude < :max_latitude AND max_latitude > :min_latitude",
                          {:min_longitude => min_longitude, :max_longitude => max_longitude, :min_latitude=>min_latitude, :max_latitude => max_latitude})
      @parks.select! do |p|
        p.intersects_trip? self
      end
      Rails.cache.write("trip:#{id}:park_ids",@parks.collect{|p| p.id})
    end
    return @parks
  end

  def geometry_as_route
    result = "["
    unless bounds_as_array.nil?
      result += bounds_as_array.collect {|coord| "[#{coord[1]},#{coord[0]}]"}.join(",")
    end

    result += "]"
  end

  def route_as_geometry
    if !self.route.blank?
      obj = JSON.parse(self.route)
      if(obj.length>0)
        obj.collect! do |value|
          "#{value[1]} #{value[0]}"
        end
      else
        return nil
      end
      return "LINESTRING (" + obj.join(", ") + ")"
    else
      return nil
    end
  end

  def bounds_as_array
    if self.geometry
      return self.geometry.gsub(/[A-Za-z]|\(|\)/,"").strip.split(',').collect{|c| c.split(" ").collect{|d| Float(d)}}
    else
      return nil
    end
  end

  def update_bounds_min_max
    if !geometry.blank? && (self.geometry_changed? || min_longitude.nil?)
      sides = sides_of_bounds
      self.min_longitude = sides[0]
      self.max_longitude = sides[1]
      self.min_latitude = sides[2]
      self.max_latitude = sides[3]
    end
  end

  def sides_of_bounds
    b_a = bounds_as_array
    longs = b_a.collect{|c| c[0]}.sort
    lats = b_a.collect{|c| c[1]}.sort
    min_long = longs[0]
    max_long = longs[-1]
    min_lat = lats[0]
    max_lat = lats[-1]
    [min_long,max_long,min_lat,max_lat]
  end

  def length_miles
    if geometry.blank?
      return 0.0
    else
      factory = ::RGeo::Geographic.spherical_factory()
      obj = factory.parse_wkt(self.geometry)
      if obj.nil?
        return 0.0
      else
        return obj.length / 1609.344
      end
    end
  end

  def categorized_attributes
    result = {}
    self.trip_features.includes(:category).each do |feature|
      unless feature.category.nil?
        if result[feature.category.name]
          result[feature.category.name] << feature
        else
          result[feature.category.name] = [feature]
        end
      end
    end

    # Category.all.each do |category|
    #   features = self.trip_features.where(:category_id=>category.id).order("id")
    #   unless features.empty?
    #     result[category.name] = features
    #   end
    # end
    result
  end

  def thumbnail_url
    if self.photos.order('id').first
      self.photos.order('id').first.flickr_large_square_url
    else
      "/assets/placeholder_item_image.png"
    end
  end

  def medium_url
    if self.photos.order('id').first
      self.photos.order('id').first.flickr_medium_url
    else
      "/assets/placeholder_item_image.png"
    end
  end

  def big_thumb
    if self.photos.order('id').first
      self.photos.order('id').first.big_thumb
    else
      "/assets/placeholder_item_image.png"
    end
  end

  def self.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    min_latitude = sw_latitude
    max_latitude = ne_latitude
    min_longitude = sw_longitude
    max_longitude = ne_longitude
    Trip.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => min_latitude, :min_longitude => min_longitude, :max_latitude => max_latitude, :max_longitude => max_longitude)
  end

  def park_name
    starting_trailhead && starting_trailhead.default_park && starting_trailhead.default_park.name
  end
end
