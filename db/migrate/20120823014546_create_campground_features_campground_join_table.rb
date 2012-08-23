class CreateCampgroundFeaturesCampgroundJoinTable < ActiveRecord::Migration
  def change
    create_table :campground_features_campgrounds, :id => false do |t|
      t.integer :campground_id
      t.integer :campground_feature_id
    end
  end
end
