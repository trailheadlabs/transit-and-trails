class Favorite < ActiveRecord::Base
  belongs_to :user
  attr_accessible :favorable_id, :favorable_type
end
