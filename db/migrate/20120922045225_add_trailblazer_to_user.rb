class AddTrailblazerToUser < ActiveRecord::Migration
  def change
    add_column :users, :trailblazer, :boolean, :default => false
  end
end
