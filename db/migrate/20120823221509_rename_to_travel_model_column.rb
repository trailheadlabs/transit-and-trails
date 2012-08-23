class RenameToTravelModelColumn < ActiveRecord::Migration
  def up
    rename_column :stories, :to_travel_model_id, :to_travel_mode_id
  end

  def down
    rename_column :stories, :to_travel_mode_id, :to_travel_model_id
  end
end
