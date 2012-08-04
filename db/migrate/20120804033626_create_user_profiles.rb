class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :firstname
      t.string :lastname
      t.string :url
      t.text :bio

      t.timestamps
    end
  end
end
