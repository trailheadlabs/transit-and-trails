class AddOrganizationAvaterToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :organization_avatar, :string
  end
end
