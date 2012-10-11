class Category < ActiveRecord::Base
  attr_accessible :description, :name, :rank, :visible

  has_many :trailhead_features
  has_many :trip_features
  has_many :campground_features

  has_paper_trail

  attr_accessible :trailhead_feature_ids
  attr_accessible :trip_feature_ids
  attr_accessible :campground_feature_ids
end
