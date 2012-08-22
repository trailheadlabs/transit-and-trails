class AddMarkerIconToFeature < ActiveRecord::Migration
  def change
    add_column :features, :marker_icon, :string
  end
end
