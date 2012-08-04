class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def authenticate_admin!
    unless user_signed_in? && current_user.admin?
      flash[:error] = "Admin user required."
      redirect_to '/users/sign_in' # halts request cycle
    end
  end
end
