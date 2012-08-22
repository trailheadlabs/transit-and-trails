class Feature < ActiveRecord::Base
  belongs_to :category

  attr_accessible :description, :link_url, :name, :rank, :id, :marker_icon, :marker_icon_cache, :remote_marker_icon_url

  mount_uploader :marker_icon, FeatureMarkerIconUploader
end
