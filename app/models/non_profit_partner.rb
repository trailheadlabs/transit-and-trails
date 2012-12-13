class NonProfitPartner < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :remote_logo_url
  has_many :parks, :inverse_of => :non_profit_partner
  has_many :trailhead_overrides, :class_name => 'Trailhead', :inverse_of => :non_profit_partner_override
  mount_uploader :logo, NonProfitPartnerLogoUploader
  has_paper_trail
end
