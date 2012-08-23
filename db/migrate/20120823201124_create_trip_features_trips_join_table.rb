class CreateTripFeaturesTripsJoinTable < ActiveRecord::Migration

  def change
    create_table :trip_features_trips, :id => false do |t|
      t.integer :trip_id
      t.integer :trip_feature_id
    end
  end
end
