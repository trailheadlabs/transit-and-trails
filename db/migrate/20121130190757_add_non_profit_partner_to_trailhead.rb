class AddNonProfitPartnerToTrailhead < ActiveRecord::Migration
  def change
    add_column :trailheads, :non_profit_partner_id, :integer
  end
end
