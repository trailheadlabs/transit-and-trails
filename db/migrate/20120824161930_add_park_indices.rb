class AddParkIndices < ActiveRecord::Migration
  def up
    add_index :parks, :name
    add_index :parks, [:min_latitude, :max_latitude, :min_longitude, :max_longitude], :name => "bounds_min_max_index"
  end

  def down
    remove_index :parks, :name
    remove_index :parks, :name => "bounds_min_max_index"
  end
end
