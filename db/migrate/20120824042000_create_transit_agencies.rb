class CreateTransitAgencies < ActiveRecord::Migration
  def change
    create_table :transit_agencies do |t|
      t.string :name
      t.string :web
      t.text :geometry

      t.timestamps
    end
  end
end
