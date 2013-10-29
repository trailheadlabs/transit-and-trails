class AddPlanAlertToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :alerts, :text
  end
end
