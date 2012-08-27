collection @maps
node :url do |m|
  m.url ? m.url : m.map.url
end

