class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :to_travel_mode, :class_name => "TravelMode", :foreign_key => "to_travel_mode_id"
  belongs_to :from_travel_mode, :class_name => "TravelMode", :foreign_key => "from_travel_mode_id"
  belongs_to :storytellable, :polymorphic => true
  attr_accessible :from_travel_mode_id, :happened_at, :story, :storytellable_id, :storytellable_type, :to_travel_mode_id
  validates :to_travel_mode, :presence => true
  validates :from_travel_mode, :presence => true
end
