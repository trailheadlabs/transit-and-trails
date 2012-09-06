class Trailhead < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  has_and_belongs_to_many :trailhead_features
  has_many :maps, :as => :mapable, :dependent => :destroy
  has_many :stories, :as => :storytellable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  scope :approved, where(:approved => true)
  has_paper_trail
  attr_accessible :description, :latitude, :longitude, :name, :rideshare, :zimride_url
  reverse_geocoded_by :latitude, :longitude

  before_create :auto_approve

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

  def categorized_attributes
    result = {}
    Category.all.each do |category|
      features = self.trailhead_features.where(:category_id=>category.id).order("id")
      if features.count > 0
        result[category.name] = features
      end
    end
    result
  end

  def default_park
    park || park_by_bounds
  end

  def agency
    default_park ? default_park.agency : nil
  end

end
