class CreateParks < ActiveRecord::Migration
  def change
    create_table :parks do |t|
      t.string :name
      t.text :description
      t.references :agency
      t.integer :acres
      t.string :county
      t.string :county_slug
      t.references :non_profit_partner
      t.text :bounds
      t.text :slug

      t.timestamps
    end
    add_index :parks, :agency_id
    add_index :parks, :non_profit_partner_id
  end
end
