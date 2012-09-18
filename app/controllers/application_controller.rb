class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Admin user required."
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
    render :json => {:key=>params[:key],:value=>session[params[:key]] || nil}
  end

  def savekv
    session[params[:key]] = params[:value]
    render :json => {:key=>params[:key],:value=>params[:value]}
  end

  def store_location
    unless params[:controller].match /devise/
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

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
