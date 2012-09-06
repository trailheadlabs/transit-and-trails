class AddSidesToTransitAgency < ActiveRecord::Migration
  def change
    add_column :transit_agencies, :min_latitude, :float
    add_column :transit_agencies, :max_latitude, :float
    add_column :transit_agencies, :min_longitude, :float
    add_column :transit_agencies, :max_longitude, :float
  end
end
