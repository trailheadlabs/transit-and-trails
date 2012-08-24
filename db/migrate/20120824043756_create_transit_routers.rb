class CreateTransitRouters < ActiveRecord::Migration
  def change
    create_table :transit_routers do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
