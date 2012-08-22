class CreateTrailheads < ActiveRecord::Migration
  def change
    create_table :trailheads do |t|
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude
      t.references :user
      t.boolean :rideshare
      t.string :zimride_url

      t.timestamps
    end
    add_index :trailheads, :user_id
  end
end
