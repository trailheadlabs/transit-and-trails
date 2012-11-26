require "point_of_interest"

class Trailhead < ActiveRecord::Base
  include PointOfInterest

  belongs_to :user, :inverse_of => :trailheads
  belongs_to :park, :inverse_of => :trailhead_overrides
  belongs_to :agency_override, :class_name => "Agency", :foreign_key => "agency_id"
  belongs_to :cached_park_by_bounds, :class_name => "Park", :foreign_key => "cached_park_by_bounds_id"
  has_and_belongs_to_many :trailhead_features
  has_many :maps, :as => :mapable, :dependent => :destroy
  has_many :stories, :as => :storytellable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  has_many :trips_starting_at, :class_name => "Trip", :foreign_key => "starting_trailhead_id"
  has_many :trips_ending_at, :class_name => "Trip", :foreign_key => "ending_trailhead_id"
  scope :approved, where(:approved => true)
  has_paper_trail
  attr_accessible :description, :latitude, :longitude, :name, :rideshare, :zimride_url, :approved,
    :park_id, :user_id, :trips_ending_at_ids, :trips_starting_at_ids, :trailhead_feature_ids, :agency_id, :class_name

  attr_accessible :maps_attributes, :allow_destroy => true
  reverse_geocoded_by :latitude, :longitude

  accepts_nested_attributes_for :maps, :allow_destroy => true

  before_save :auto_approve, :update_park_by_bounds

  validates :name, :presence => true, :uniqueness => true

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

end
