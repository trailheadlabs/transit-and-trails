class AddNameToFeaturedTab < ActiveRecord::Migration
  def change
    add_column :featured_tabs, :name, :string
  end
end
