class AddApprovedToTrip < ActiveRecord::Migration
  def up
    add_column :trips, :approved, :boolean, :default => 't'
    Trip.update_all(approved: true)
  end

  def down
    remove_column :trips, :approved
  end
end
