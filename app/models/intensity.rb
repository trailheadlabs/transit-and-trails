class Intensity < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :trips
end
