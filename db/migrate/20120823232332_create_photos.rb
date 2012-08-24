class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :photoable_id
      t.string :photoable_type
      t.string :flickr_id
      t.references :user
      t.boolean :uploaded_to_flickr
      t.string :image

      t.timestamps
    end
    add_index :photos, :user_id
  end
end
