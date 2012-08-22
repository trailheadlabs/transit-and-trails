class AddBoundsMaxMinToPark < ActiveRecord::Migration
  def change
    add_column :parks, :min_longitude, :float
    add_column :parks, :max_longitude, :float
    add_column :parks, :min_latitude, :float
    add_column :parks, :max_latitude, :float
  end
end
