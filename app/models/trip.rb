class Trip < ActiveRecord::Base
  belongs_to :user
  belongs_to :intensity
  belongs_to :duration
  has_and_belongs_to_many :trip_features
  has_many :stories, :as => :storytellable
  attr_accessible :description, :ending_trailhead_id, :name, :route, :starting_trailhead_id
end
