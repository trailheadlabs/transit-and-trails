class UserProfile < ActiveRecord::Base
  attr_accessible :bio, :firstname, :lastname, :url, :user_id, :avatar,
                  :avatar_cache, :remote_avatar_url, :organization_avatar,
                  :organization_avatar_cache, :remote_organization_avatar_url,
                  :city, :state, :zip, :address1, :address2, :organization_name,
                  :organization_url, :website_address, :signup_source

  belongs_to :user

  mount_uploader :avatar, UserProfileAvatarUploader
  mount_uploader :organization_avatar, UserProfileOrganizationAvatarUploader
  has_paper_trail

  before_create :generate_api_key

  def generate_api_key
    self.api_key = Digest::SHA256.hexdigest(SecureRandom::random_bytes)
    self.api_secret = Digest::SHA256.hexdigest(SecureRandom::random_bytes)
  end

end
