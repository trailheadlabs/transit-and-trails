object @user
attributes :id, :email
glue :user_profile do
  attributes :organization_name => :organization_name, :firstname => :first_name, :lastname => :last_name, :website_address => :website_url
  glue :avatar do
    attributes :url => :avatar_url
    glue :thumbnail do
      attributes :url => :avatar_thumbnail_url
    end
  end
  glue :organization_avatar do
    attributes :url => :organization_avatar_url
    glue :thumbnail do
      attributes :url => :organization_avatar_thumbnail_url
    end
  end

end
attributes :username
