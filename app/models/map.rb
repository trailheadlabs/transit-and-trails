class Map < ActiveRecord::Base
  belongs_to :user
  belongs_to :mapable, :polymorphic => true
  attr_accessible :description, :map, :mapable_id, :mapable_type, :name, :url,
    :map_cache, :remote_map_url
  mount_uploader :map, MapUploader
end
