class Partner < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :logo_remote_url

  mount_uploader :logo, PartnerLogoUploader
end
