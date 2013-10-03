class CreateAgenciesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :agencies_users, :id => false do |t|
      t.integer :user_id
      t.integer :agency_id
    end

    add_index :agencies_users, [:user_id,:agency_id]
  end
end
