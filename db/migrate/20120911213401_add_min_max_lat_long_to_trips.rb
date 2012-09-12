class AddMinMaxLatLongToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :min_longitude, :float
    add_column :trips, :max_longitude, :float
    add_column :trips, :min_latitude, :float
    add_column :trips, :max_latitude, :float
  end
end
