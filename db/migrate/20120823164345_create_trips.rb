class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.text :description
      t.references :user
      t.references :intensity
      t.references :duration
      t.integer :starting_trailhead_id
      t.integer :ending_trailhead_id
      t.text :route

      t.timestamps
    end
    add_index :trips, :user_id
    add_index :trips, :intensity_id
    add_index :trips, :duration_id
  end
end
