class AddOrganizationToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :organization_name, :string
    add_column :user_profiles, :organization_url, :string
  end
end
