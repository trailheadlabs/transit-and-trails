object @trailhead
cache ['v5',@trailhead]
attributes :id, :name, :description, :longitude, :latitude, :distance 
node :non_profit_partner_id do |t|
  t.non_profit_partner ? t.non_profit_partner.id : nil
end
node :non_profit_partner_name do |t|
  t.non_profit_partner ? t.non_profit_partner.name : nil
end
node :non_profit_partner_website do |t|
  t.non_profit_partner ? t.non_profit_partner.link : nil
end

attributes :user_id => :author_id
node :park_name do |t|
  t.default_park ? t.default_park.name : nil
end
node :park_agency_id do |t|
  (t.default_park && t.default_park.agency) ? t.default_park.agency.id : nil
end
node :park_agency_name do |t|
  (t.default_park && t.default_park.agency) ? t.default_park.agency.name : nil
end
node :park_agency_website do |t|
  (t.default_park && t.default_park.agency) ? t.default_park.agency.link : nil
end
node :trip_ids do |t|
  t.trips_starting_at.pluck(:id)
end

