class TransitAgency < ActiveRecord::Base
  attr_accessible :geometry, :name, :web, :min_longitude, :max_longitude,
    :min_latitude, :max_latitude
  has_and_belongs_to_many :transit_routers
  before_save :update_geometry_min_max

  def update_geometry_min_max
    if !geometry.blank? && (self.geometry_changed? || min_longitude.nil?)
      sides = sides_of_geometry
      self.min_longitude = sides[0]
      self.max_longitude = sides[1]
      self.min_latitude = sides[2]
      self.max_latitude = sides[3]
    end
  end

  def geometry_as_array
    self.geometry.gsub(/[A-Za-z]|\(|\)/,"").strip.split(',').collect{|c| c.split(" ").collect{|d| Float(d)}}
  end

  def sides_of_geometry
    b_a = geometry_as_array
    longs = b_a.collect{|c| c[0]}.sort
    lats = b_a.collect{|c| c[1]}.sort
    min_long = longs[0]
    max_long = longs[-1]
    min_lat = lats[0]
    max_lat = lats[-1]
    [min_long,max_long,min_lat,max_lat]
  end

end
