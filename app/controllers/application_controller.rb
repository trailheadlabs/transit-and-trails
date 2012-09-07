class ApplicationController < ActionController::Base
  protect_from_forgery
  helper TextHelper
  before_filter :store_location

  def index
    @trailheads = Trailhead.approved.near("5692 Cabot Drive, Oakland CA").limit(10)
    @location = request.location
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:error] = "Admin user required."
      redirect_to '/' # halts request cycle
    end
  end

  def apply_limit_and_offset(params,records)
    if params[:limit]
      records = records.limit(Integer(params[:limit]))
    end
    if params[:offset]
      records = records.offset(Integer(params[:offset]))
    end
    return records
  end

  def loadkv
    render :text => session[params[:key]] || ''
  end

  def savekv
    session[params[:key]] = params[:value]
    render :ok
  end

  def store_location
    unless params[:controller] == "devise/sessions"
      url = request.referrer
      session[:user_return_to] = url
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || root_path
  end

end
