class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name
      t.text :description
      t.integer :mapable_id
      t.string :mapable_type
      t.string :url
      t.references :user
      t.string :map

      t.timestamps
    end
    add_index :maps, :user_id
  end
end
