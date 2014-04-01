object @trailhead
cache @trailhead
attributes :id, :name, :description, :longitude, :latitude, :distance
attributes :user_id => :author_id
node :park_name do |t|
  t.default_park ? t.default_park.name : nil
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

