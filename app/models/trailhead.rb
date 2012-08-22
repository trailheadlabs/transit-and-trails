class Trailhead < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :trailhead_features

  attr_accessible :description, :latitude, :longitude, :name, :rideshare, :zimride_url
  reverse_geocoded_by :latitude, :longitude
end
