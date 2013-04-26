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

  def external_url
    _external_url = ""
    if !website_address.blank?
      _external_url = website_address
    elsif !organization_url.blank?
      _external_url organization_url
    elsif !url.blank?
      _external_url = url
    end
    unless _external_url.blank? || (_external_url.starts_with? "http")
      _external_url = "http://" + _external_url
    end
    return _external_url
  end

  def name
    if(!firstname.blank? && !lastname.blank?)
      "#{firstname} #{lastname}"
    elsif(!organization_name.blank?)
      "#{organization_name}"
    else
      user.username
    end
  end

end
