class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_user!
    url = params[:next_url] || request.fullpath
    session[:user_return_to] = url
    super
  end

  def authenticate_admin!
    url = params[:next_url] || request.fullpath
    session[:user_return_to] = url
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Admin user required."
      redirect_to '/' # halts request cycle
    end
  end

  def valid_api_key!
    if Rails.env.production?
      unless UserProfile.where(:api_key=>params[:key]).exists?
        render :json => {:code=>401,:message=>"Unauthorized"}, :status => :unauthorized
      end
    end
  end

  def valid_admin_api_key!
    if Rails.env.production?
      unless UserProfile.where(:api_key=>params[:key]).exists? && UserProfile.where(:api_key=>params[:key].user.is_admin?)
        render :json => {:code=>401,:message=>"Unauthorized"}, :status => :unauthorized
      end
    end
  end

  def embed_authenticate_trailblazer!
    Rails.logger.info("embed_authenticate_trailblazer!")
    url = params[:next_url] || request.fullpath
    session[:user_return_to] = url
    Rails.logger.info("session[:user_return_to] = #{session[:user_return_to]}")
    unless user_signed_in? && current_user.trailblazer?
      flash[:alert] = "Please login as a Trail Blazer to access that page."
      redirect_to '/embed/sessions/new' # halts request cycle
    end
  end

  def embed_authenticate_admin!
    url = params[:next_url] || request.fullpath
    session[:user_return_to] = url

    unless user_signed_in? && current_user.admin?
      flash[:alert] = "Please login as an admin to access that page."
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

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    Rails.logger.info("session[:user_return_to] = #{session[:user_return_to]}")
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    Rails.logger.info("session[:user_return_to] = #{session[:user_return_to]}")
    stored_location_for(resource) || root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
