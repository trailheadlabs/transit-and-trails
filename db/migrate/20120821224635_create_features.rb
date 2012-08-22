class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.text :description
      t.text :link_url
      t.integer :rank
      t.references :category

      t.timestamps
    end
    add_index :features, :category_id
  end
end
