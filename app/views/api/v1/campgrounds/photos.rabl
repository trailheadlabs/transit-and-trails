collection @photos
attributes :flickr_id => :id
node :flickr_url do |p|
  p.flickr_url
end
node :medium do |p|
  p.flickr_medium_url
end
node :original do |p|
  p.flickr_original_url || p.flickr_large_url
end
node :square do |p|
  p.flickr_square_url
end
node :thumbnail do |p|
  p.flickr_thumbnail_url
end

