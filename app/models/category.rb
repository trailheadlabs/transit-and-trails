class Category < ActiveRecord::Base
  attr_accessible :description, :name, :rank, :visible

  has_many :trailhead_features
  has_many :trip_features
  has_many :campground_features

  has_paper_trail
end
