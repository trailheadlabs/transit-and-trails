class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :django_password
  # attr_accessible :title, :body

  has_one :user_profile

  alias :devise_valid_password? :valid_password?

  def valid_password?(password)
    if(encrypted_password.blank?)
      salt = django_password.split('$')[1]
      old_hash = django_password.split('$')[2]
      Rails.logger.info "Salt = #{salt}"
      return false unless Digest::SHA1.hexdigest(salt+password) == old_hash
      Rails.logger.info "User #{email} is using the old password hashing method, updating attribute."
      self.password = password
      true
    else
      devise_valid_password?(password)
    end
  end

end
