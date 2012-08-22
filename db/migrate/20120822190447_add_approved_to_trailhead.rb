class AddApprovedToTrailhead < ActiveRecord::Migration
  def change
    add_column :trailheads, :approved, :boolean
  end
end
