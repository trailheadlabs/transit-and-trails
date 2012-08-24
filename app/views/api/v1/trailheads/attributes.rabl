collection @attributes
attributes :id, :name
glue :category do
  attributes :id => :category_id, :name => :category_name
end
