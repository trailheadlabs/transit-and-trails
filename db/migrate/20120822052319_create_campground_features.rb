class CreateCampgroundFeatures < ActiveRecord::Migration
  def change
    create_table :campground_features do |t|
      t.string :name
      t.text :description
      t.string :marker_icon
      t.integer :rank
      t.string :link_url
      t.references :category

      t.timestamps
    end
    add_index :campground_features, :category_id
  end
end
