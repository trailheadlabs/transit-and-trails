object @trailhead_attribute
attributes :id, :name, :description
glue :category do
  attributes :id => :category
end


