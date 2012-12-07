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

  before_save :auto_approve, :park_by_bounds

  has_paper_trail

  def categorized_attributes
    result = {}
    Category.all.each do |category|
      features = self.campground_features.where(:category_id=>category.id).order("id")
      if features.count > 0
        result[category.name] = features
      end
    end
    result
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
