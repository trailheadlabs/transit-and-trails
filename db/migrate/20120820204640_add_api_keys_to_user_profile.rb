class AddApiKeysToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :api_key, :string
    add_column :user_profiles, :api_secret, :string
  end
end
