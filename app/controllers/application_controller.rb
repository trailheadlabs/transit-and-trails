class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:error] = "Admin user required."
      redirect_to '/' # halts request cycle
    end
  end
end
