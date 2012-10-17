class AddAgencyIdToTrailhead < ActiveRecord::Migration
  def change
    add_column :trailheads, :agency_id, :integer
  end
end
