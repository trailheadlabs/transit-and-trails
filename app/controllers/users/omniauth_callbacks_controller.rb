class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :store_location
  skip_before_filter :verify_authenticity_token, :only => [:facebook,:auth]

  def facebook
    auth
  end

  def auth
    auth = request.env['omniauth.auth']
    Rails.logger.info(auth.to_yaml)
    # Find an identity here
    @identity = Identity.find_with_omniauth(auth)

    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end

    if signed_in?
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        redirect_to root_url, notice: "Already linked that account!"
      else
        # The identity is not associated with the current_user so lets
        # associate the identity
        @identity.user = current_user
        @identity.save()
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      if @identity.user.present?
        # The identity we found had a user associated with it so let's
        # just log them in here
        sign_in_and_redirect @identity.user, :event => :authentication
      else
        # No user associated with the identity so we need to create a new one
        session['identity.id'] = @identity.id
        session['omniauth.data'] = request.env['omniauth.auth']['info']
        redirect_to new_user_registration_url, notice: "Please finish signing up."
      end
    end
  end

end