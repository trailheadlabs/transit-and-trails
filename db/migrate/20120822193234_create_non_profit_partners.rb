class CreateNonProfitPartners < ActiveRecord::Migration
  def change
    create_table :non_profit_partners do |t|
      t.string :name
      t.text :description
      t.string :link
      t.string :logo

      t.timestamps
    end
  end
end
