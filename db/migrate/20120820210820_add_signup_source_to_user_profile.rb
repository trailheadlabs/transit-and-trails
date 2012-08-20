class AddSignupSourceToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :signup_source, :string
  end
end
