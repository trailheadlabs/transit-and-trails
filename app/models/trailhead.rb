require "point_of_interest"

class Trailhead < ActiveRecord::Base
  include PointOfInterest

  belongs_to :user, :inverse_of => :trailheads
  belongs_to :park, :inverse_of => :trailhead_overrides
  belongs_to :non_profit_partner, :inverse_of => :trailhead_overrides
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
  attr_accessible :description,
                  :latitude,
                  :longitude,
                  :name,
                  :rideshare,
                  :zimride_url,
                  :approved,
                  :park_name,
                  :agency_name,
                  :park_id,
                  :user_id,
                  :trips_ending_at_ids,
                  :trips_starting_at_ids,
                  :trailhead_feature_ids,
                  :agency_id,
                  :non_profit_partner_id,
                  :non_profit_partner_name

  attr_accessible :maps_attributes, :allow_destroy => true
  reverse_geocoded_by :latitude, :longitude

  accepts_nested_attributes_for :maps, :allow_destroy => true

  before_save :auto_approve, :update_park_by_bounds

  validates :name, :presence => true, :uniqueness => true

  alias :non_profit_partner_attr :non_profit_partner
  def non_profit_partner
    (non_profit_partner_id && self.non_profit_partner_attr) || (default_park && default_park.non_profit_partner)
  end

  def non_profit_partner_name
    non_profit_partner_id && non_profit_partner.name
  end

  def non_profit_partner_name=(val)
  end

  def park_name
    park && park.name
  end

  def park_name=(val)
  end

  def agency_name
    agency_override && agency_override.name
  end

  def agency_name=(val)
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

  # GET /trailheads/within_bounds
  # GET /trailheads/within_bounds.json
  def self.within_bounds(sw_latitude,sw_longitude,ne_latitude,ne_longitude)
    min_latitude = sw_latitude
    max_latitude = ne_latitude
    min_longitude = sw_longitude
    max_longitude = ne_longitude
    Trailhead.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => min_latitude, :min_longitude => min_longitude, :max_latitude => max_latitude, :max_longitude => max_longitude)
  end

end
