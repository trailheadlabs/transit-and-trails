class CampgroundFeature < ActiveRecord::Base
  belongs_to :category
  attr_accessible :description, :link_url, :marker_icon, :name, :rank
  mount_uploader :marker_icon, CampgroundFeatureMarkerIconUploader
end
