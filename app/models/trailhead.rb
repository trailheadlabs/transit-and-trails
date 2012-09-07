require "point_of_interest"

class Trailhead < ActiveRecord::Base
  include PointOfInterest

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
