class CreateRecentActivities < ActiveRecord::Migration
  def change
    create_table :recent_activities do |t|
      t.string :name
      t.text :description
      t.boolean :highlighted
      t.text :recent_news_text
      t.string :favorites_link1
      t.string :favorites_type1
      t.string :favorites_link2
      t.string :favorites_type2
      t.string :favorites_link3
      t.string :favorites_type3
      t.string :favorites_link4
      t.string :favorites_type4
      t.string :favorites_link5
      t.string :favorites_type5
      t.text :favorites_link1_text
      t.text :favorites_link2_text
      t.text :favorites_link3_text
      t.text :favorites_link4_text
      t.text :favorites_link5_text

      t.timestamps
    end
  end
end
