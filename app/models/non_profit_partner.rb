class NonProfitPartner < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :remote_logo_url
  mount_uploader :logo, NonProfitPartnerLogoUploader
  has_many :parks
end
