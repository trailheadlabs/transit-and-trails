class CreateCampgrounds < ActiveRecord::Migration
  def change
    create_table :campgrounds do |t|
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude
      t.references :user
      t.references :park
      t.boolean :approved

      t.timestamps
    end
    add_index :campgrounds, :user_id
    add_index :campgrounds, :park_id
  end
end
