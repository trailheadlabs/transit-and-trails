class FixApprovedDefaultOnTrip < ActiveRecord::Migration
  def change
    change_column :trips, :approved, :boolean, :default => true
  end

end
