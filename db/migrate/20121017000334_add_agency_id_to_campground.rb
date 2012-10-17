class AddAgencyIdToCampground < ActiveRecord::Migration
  def change
    add_column :campgrounds, :agency_id, :integer
  end
end
