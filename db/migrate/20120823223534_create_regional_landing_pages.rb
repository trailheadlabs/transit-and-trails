class CreateRegionalLandingPages < ActiveRecord::Migration
  def change
    create_table :regional_landing_pages do |t|
      t.string :name
      t.text :description
      t.string :path
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
