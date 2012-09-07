module PointOfInterest
  def auto_approve
    if user && (user.trailblazer? || user.admin)
      self.approved = true
    end
  end

  def park_by_bounds
    Park.where(":latitude > min_latitude AND :latitude < max_latitude AND :longitude > min_longitude AND :longitude < max_longitude",
      :latitude => self.latitude, :longitude => self.longitude).first
  end

  def transit_agencies
    TransitAgency.where(":latitude > min_latitude AND :latitude < max_latitude AND :longitude > min_longitude AND :longitude < max_longitude",
      :latitude => self.latitude, :longitude => self.longitude)
  end

  def transit_routers
    TransitRouter.where(:id=>transit_agencies.collect{|c|c.id})
  end

  def default_park
    park || park_by_bounds
  end

  def agency
    default_park ? default_park.agency : nil
  end

end
