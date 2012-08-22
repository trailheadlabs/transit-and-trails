class TrailheadFeature < ActiveRecord::Base
  belongs_to :category
  has_and_belongs_to_many :trailheads
  attr_accessible :description, :link_url, :marker_icon, :name, :rank, :marker_icon_cache, :remote_marker_icon_url

  mount_uploader :marker_icon, TrailheadFeatureMarkerIconUploader
end
