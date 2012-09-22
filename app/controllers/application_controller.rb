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

  def embed_authenticate_trailblazer!
    unless user_signed_in? && current_user.trailblazer?
      flash[:alert] = "Please login as a Trail Blazer to access that page."
      redirect_to '/embed/sessions/new' # halts request cycle
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
    unless params[:controller].match /devise|signup|signin/
      url = params[:next_url] || request.referrer
      session[:user_return_to] = url
    else
      session[:user_return_to] = params[:next_url]
    end
    Rails.logger.info("session[:user_return_to] = #{session[:user_return_to]}")

  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    Rails.logger.info("session[:user_return_to] = #{session[:user_return_to]}")
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
