class CreateFeaturedTabs < ActiveRecord::Migration
  def change
    create_table :featured_tabs do |t|
      t.boolean :highlighted
      t.string :header
      t.text :text1
      t.text :text2
      t.text :text3
      t.string :image
      t.string :image_link
      t.string :link1
      t.text :link1_text
      t.string :link2
      t.text :link2_text
      t.string :link3
      t.text :link3_text
      t.string :link4
      t.text :link4_text
      t.string :link5
      t.text :link5_text

      t.timestamps
    end
  end
end
