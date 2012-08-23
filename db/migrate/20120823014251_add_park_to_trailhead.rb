class AddParkToTrailhead < ActiveRecord::Migration
  def change
    add_column :trailheads, :park_id, :integer
  end
end
