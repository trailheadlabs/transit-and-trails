class AddAddressToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :address1, :string
    add_column :user_profiles, :address2, :string
    add_column :user_profiles, :city, :string
    add_column :user_profiles, :state, :string
    add_column :user_profiles, :zip, :string
  end
end
