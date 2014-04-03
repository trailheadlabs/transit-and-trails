class AddOtdsFieldsToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :otds_id, :integer
    add_index :trailheads, :otds_id
    add_column :agencies, :otds_id, :integer
    add_index :agencies, :otds_id
  end
end
