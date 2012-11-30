class AddCoordinatesToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :latitude, :float
    add_column :trips, :longitude, :float
    Trip.all.each{|t| t.save}
  end

  def down
    remove_column :trips, :latitude
    remove_column :trips, :longitude
  end
end
