class AddCachedParkByBoundsToCampground < ActiveRecord::Migration
  def change
    add_column :campgrounds, :cached_park_by_bounds_id, :integer
  end
end
