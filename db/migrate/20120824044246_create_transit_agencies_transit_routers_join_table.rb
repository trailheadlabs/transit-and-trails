class CreateTransitAgenciesTransitRoutersJoinTable < ActiveRecord::Migration
  def change
    create_table :transit_agencies_transit_routers, :id => false do |t|
      t.integer :transit_agency_id
      t.integer :transit_router_id
    end
  end
end
