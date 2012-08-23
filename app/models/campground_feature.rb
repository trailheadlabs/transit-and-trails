class CampgroundFeature < ActiveRecord::Base
  belongs_to :category
  attr_accessible :description, :link_url, :marker_icon, :name, :rank, :marker_icon_cache, :remote_marker_icon_url
  mount_uploader :marker_icon, CampgroundFeatureMarkerIconUploader
  has_paper_trail
end
