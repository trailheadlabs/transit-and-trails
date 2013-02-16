class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :favorable_id
      t.string :favorable_type
      t.references :user

      t.timestamps
    end
    add_index :favorites, :user_id
  end
end
