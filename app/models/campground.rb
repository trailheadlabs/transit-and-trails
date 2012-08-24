class Campground < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  has_many :maps, :as => :mapable
  has_many :photos, :as => :photoable

  has_and_belongs_to_many :campground_features
  attr_accessible :approved, :description, :latitude, :longitude, :name
end
