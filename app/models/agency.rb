class Agency < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :remote_logo_url
  mount_uploader :logo, AgencyLogoUploader
  has_paper_trail
  has_many :parks, :inverse_of => :agency
end
