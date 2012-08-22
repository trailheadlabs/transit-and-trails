class CreateTripFeatures < ActiveRecord::Migration
  def change
    create_table :trip_features do |t|
      t.string :name
      t.text :description
      t.string :marker_icon
      t.integer :rank
      t.string :link_url
      t.references :category

      t.timestamps
    end
    add_index :trip_features, :category_id
  end
end
