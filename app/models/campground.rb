require "point_of_interest"

class Campground < ActiveRecord::Base
  include PointOfInterest

  belongs_to :user
  belongs_to :park
  belongs_to :agency_override, :class_name => "Agency", :foreign_key => "agency_id"
  belongs_to :cached_park_by_bounds, :class_name => "Park", :foreign_key => "cached_park_by_bounds_id"
  has_many :maps, :as => :mapable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  has_many :stories, :as => :storytellable, :dependent => :destroy
  
  scope :approved, where(:approved => true)
  
  has_and_belongs_to_many :campground_features
  attr_accessible :approved,
                  :description,
                  :latitude,
                  :longitude,
                  :name,
                  :campground_feature_ids,
                  :agency_id,
                  :user_id
  reverse_geocoded_by :latitude, :longitude

  validates :name, :presence => true, :uniqueness => true

  before_save :park_by_bounds

  before_create :auto_approve
  has_paper_trail
  
  after_save :touch_park

  def touch_park
    default_park.touch if default_park
    park.touch if park
  end
  
  def categorized_attributes
    result = {}
    self.campground_features.includes(:category).each do |feature|
      if result[feature.category.name]
        result[feature.category.name] << feature
      else
        result[feature.category.name] = [feature]
      end
    end

    # Category.all.each do |category|
    #   features = self.campground_features.where(:category_id=>category.id).order("id")
    #   if features.count > 0
    #     result[category.name] = features
    #   end
    # end
    result
  end

  def thumbnail_url
    if self.photos.first
      self.photos.first.flickr_large_square_url
    else
      "/assets/placeholder_item_image.png"
    end
  end

  def self.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    min_latitude = sw_latitude
    max_latitude = ne_latitude
    min_longitude = sw_longitude
    max_longitude = ne_longitude
    self.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => min_latitude, :min_longitude => min_longitude, :max_latitude => max_latitude, :max_longitude => max_longitude)
  end


end
