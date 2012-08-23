class Park < ActiveRecord::Base
  belongs_to :agency
  belongs_to :non_profit_partner
  attr_accessible :acres, :bounds, :county, :county_slug, :description, :name, :slug, :link,
    :min_longitude, :max_longitude, :min_latitude, :max_latitude
  before_update :update_bounds_min_max

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

  def bounds_as_array
    self.bounds.gsub(/[A-Za-z]|\(|\)/,"").strip.split(',').collect{|c| c.split(" ").collect{|d| Float(d)}}
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

  def polys
    tmp = bounds.gsub(/[A-Za-z]|\)/,"").strip.split('(').select{|c| !c.blank?}
    tmp.collect!{ |c|c.strip.split(',').collect{|e| e.split(" ").collect{|d| Float(d)}} }
  end
end
