class Park < ActiveRecord::Base
  belongs_to :agency
  belongs_to :non_profit_partner
  attr_accessible :acres, :bounds, :county, :county_slug, :description, :name, :slug, :link

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
