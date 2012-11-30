class AddApprovedToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :approved, :boolean, :default => false
  end
end
