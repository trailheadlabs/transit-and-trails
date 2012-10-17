module PointOfInterest
  def auto_approve
    if user && (user.trailblazer? || user.admin)
      self.approved = true
    end
  end

  def park_by_bounds
    parks = Park.where(":latitude > min_latitude AND :latitude < max_latitude AND :longitude > min_longitude AND :longitude < max_longitude",
      :latitude => self.latitude, :longitude => self.longitude)
    # if false
    if RGeo::Geos::supported?
      factory = ::RGeo::Geographic.simple_mercator_factory()
      parks.select! do |p|
        park_obj = factory.parse_wkt(p.bounds)
        point_obj = factory.point(self.longitude,self.latitude)
        park_obj.contains? point_obj
      end
    else
      parks.select! do |p|
        p.contains_trailhead? self
      end
    end

    self.cached_park_by_bounds = parks.first
    self.save
    return parks.first
  end

  def transit_agencies
    TransitAgency.where(":latitude > min_latitude AND :latitude < max_latitude AND :longitude > min_longitude AND :longitude < max_longitude",
      :latitude => self.latitude, :longitude => self.longitude)
  end

  def transit_routers
    transit_agencies.collect{|c|c.transit_routers}.uniq.select{|c|!c.empty?}.flatten
  end

  def default_park
    @default_park ||= (park || cached_park_by_bounds || park_by_bounds)
  end

  
  def agency
    agency_override || default_park && default_park.agency || nil
  end

end
