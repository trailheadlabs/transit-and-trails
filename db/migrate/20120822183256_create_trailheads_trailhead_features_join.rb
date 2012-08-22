class CreateTrailheadsTrailheadFeaturesJoin < ActiveRecord::Migration

  def change
    create_table :trailhead_features_trailheads, :id => false do |t|
      t.integer :trailhead_id
      t.integer :trailhead_feature_id
    end
  end

end
