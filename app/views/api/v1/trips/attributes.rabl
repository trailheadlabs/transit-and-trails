collection @attributes
attributes :id, :name
glue :category do
  attributes :id => :category, :name => :category_name
end
