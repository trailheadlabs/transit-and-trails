class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    Rails.logger.info('MY CREATE')
    super
    Rails.logger.info('AFTER SUPER')
    Rails.logger.info("SESSION = #{session['identity.id']}")
    if session.has_key? 'identity.id'
      Rails.logger.info("USER_ID = #{@user.id}")
      Identity.find(session['identity.id']).update_attributes(:user_id=>@user.id)
      session['identity.id'] = nil;
    end
  rescue Exception => e
    Rails.logger.error e
    raise e
    super
  end
end