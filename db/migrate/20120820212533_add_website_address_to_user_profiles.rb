class AddWebsiteAddressToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :website_address, :string
  end
end
