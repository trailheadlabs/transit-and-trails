class AddUserIdToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :user_id, :integer
  end
end
