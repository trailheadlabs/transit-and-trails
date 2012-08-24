class TransitAgency < ActiveRecord::Base
  attr_accessible :geometry, :name, :web
  has_and_belongs_to_many :transit_routers
end
