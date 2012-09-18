require "point_of_interest"

class Campground < ActiveRecord::Base
  include PointOfInterest

  belongs_to :user
  belongs_to :park
  belongs_to :cached_park_by_bounds, :class_name => "Park", :foreign_key => "cached_park_by_bounds_id"
  has_many :maps, :as => :mapable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  has_many :stories, :as => :storytellable, :dependent => :destroy

  has_and_belongs_to_many :campground_features
  attr_accessible :approved, :description, :latitude, :longitude, :name, :campground_feature_ids
  reverse_geocoded_by :latitude, :longitude

  validates :name, :presence => true, :uniqueness => true

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

end
