class AddCachedParkByBoundsToTrailhead < ActiveRecord::Migration
  def change
    add_column :trailheads, :cached_park_by_bounds_id, :integer
  end
end
