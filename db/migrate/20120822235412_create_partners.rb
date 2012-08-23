class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.text :description
      t.string :link
      t.string :logo

      t.timestamps
    end
  end
end
