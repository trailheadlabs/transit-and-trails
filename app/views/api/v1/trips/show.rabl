object @trip
attributes :id, :name, :description, :ending_trailhead_id, :starting_trailhead_id
attributes :user_id => :author_id
child(:starting_trailhead => :starting_trailhead) { attributes :latitude, :longitude }
glue :duration do
  attributes :name => :duration
end
glue :intensity do
  attributes :name => :intensity
end
node :length_miles do |t|
  t.length_miles
end
