class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
