class NonProfitPartner < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :remote_logo_url
  has_many :parks
  mount_uploader :logo, NonProfitPartnerLogoUploader
  has_paper_trail
end
