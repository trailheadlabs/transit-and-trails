object @trailhead
attributes :id, :name, :description, :longitude, :latitude
attributes :user_id => :author_id
node :park_name do |t|
  t.default_park ? t.default_park.name : nil
end
