object @user
attributes :id, :username
glue :user_profile do
  attributes :firstname => :first_name, :lastname => :last_name
end
