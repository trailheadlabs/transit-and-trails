class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :django_password, :user_profile, :admin, :role_ids
  # attr_accessible :title, :body

  has_one :user_profile

  has_many :trailheads, :inverse_of => :user

  has_and_belongs_to_many :roles

  has_paper_trail

  before_create :populate_user_profile

  accepts_nested_attributes_for :user_profile

  alias :devise_valid_password? :valid_password?

  validates :username, :email, :presence => true

  validates :username, :uniqueness => true

  def self.users_for_role(role_name)
    Role.find_by_name(role_name) && Role.find_by_name(role_name).users
  end

  def self.trailblazers
    users_for_role('trailblazer')
  end

  def self.admins
    users_for_role('admin')
  end

  def self.baynature_trailblazers
    users_for_role('baynature_trailblazers')
  end

  def self.baynature_admins
    users_for_role('baynature_admin')
  end

  def populate_user_profile
    build_user_profile unless user_profile
  end

  def add_role(role_sym)
    if !roles.find_by_name(role_sym.to_s)
    roles << Role.find_by_name(role_sym.to_s)
  end

  def has_role?(role_sym)
    roles.exists?(name: role_sym.to_s)
  end

  def admin?
    has_role? :admin
  end

  def trailblazer?
    has_role? :trailblazer
  end

  def baynature_trailblazer?
    has_role? :baynature_trailblazer
  end

  def baynature_admin?
    has_role? :baynature_admin
  end

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
