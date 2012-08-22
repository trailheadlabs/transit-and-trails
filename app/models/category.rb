class Category < ActiveRecord::Base
  attr_accessible :description, :name, :rank, :visible

  has_many :features
end
