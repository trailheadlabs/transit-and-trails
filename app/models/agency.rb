class Agency < ActiveRecord::Base
  attr_accessible :description, :link, :logo, :name, :logo_cache, :remote_logo_url, :user_ids
  mount_uploader :logo, AgencyLogoUploader
  has_paper_trail
  has_many :parks, :inverse_of => :agency
  has_and_belongs_to_many :users

  after_save :touch_parks
  
  def touch_parks
    parks.each do |p|
      p.touch
    end
  end

end
