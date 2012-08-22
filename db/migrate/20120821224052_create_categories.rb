class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.boolean :visible
      t.integer :rank

      t.timestamps
    end
  end
end
