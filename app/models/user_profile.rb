class UserProfile < ActiveRecord::Base
  attr_accessible :bio, :firstname, :lastname, :url

  belongs_to :user
end
