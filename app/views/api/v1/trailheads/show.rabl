object @trailhead
attributes :id, :name, :description, :longitude, :latitude
attributes :user_id => :author_id
node :park_name do |t|
  t.park_by_bounds ? t.park_by_bounds.name : nil
end
