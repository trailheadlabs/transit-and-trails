class UserProfile < ActiveRecord::Base
  attr_accessible :bio, :firstname, :lastname, :url, :user_id, :avatar,
                  :avatar_cache, :remote_avatar_url

  belongs_to :user

  mount_uploader :avatar, UserProfileAvatarUploader
end
