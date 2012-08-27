class AddGeometryToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :geometry, :text
  end
end
