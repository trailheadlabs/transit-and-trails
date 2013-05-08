class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    super
    flash[:alert] = 'Signed Up!'
    if session.has_key? 'identity.id'
      Identity.find(session['identity.id']).update_attributes(:user_id=>@user.id)
      session['identity.id'] = nil;
    end
  rescue Exception => e
    Rails.logger.error e
    raise e
    super
  end

 protected

  def after_sign_up_path_for(resource)
    find_trips_path
  end

  def after_inactive_sign_up_path_for(resource)
    find_trips_path
  end
end