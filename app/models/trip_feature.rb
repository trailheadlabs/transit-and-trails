class TripFeature < ActiveRecord::Base
  belongs_to :category
  attr_accessible :description, :link_url, :marker_icon, :name, :rank, :marker_icon_cache, :remote_marker_icon_url
  has_and_belongs_to_many :trips

  mount_uploader :marker_icon, TripFeatureMarkerIconUploader

  has_paper_trail
end
