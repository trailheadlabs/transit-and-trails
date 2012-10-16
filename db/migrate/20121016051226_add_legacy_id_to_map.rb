class AddLegacyIdToMap < ActiveRecord::Migration
  def change
    add_column :maps, :legacy_id, :integer
  end
end
