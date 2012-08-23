class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :storytellable_id
      t.string :storytellable_type
      t.references :user
      t.text :story
      t.datetime :happened_at
      t.integer :to_travel_model_id
      t.integer :from_travel_mode_id

      t.timestamps
    end
    add_index :stories, :user_id
  end
end
