class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.text :description
      t.text :link
      t.string :logo

      t.timestamps
    end
  end
end
