class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Please login as a user that can access that."
    redirect_to new_user_session_path
  end
  before_filter :store_location, :except => {:controller=>[:devise_session,:embed_session]}
  skip_before_filter :store_location, :only => [:loadkv,:savekv]
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :only => [:safari_cookie_set]

  def safari_cookie_set
    cookies[:safari_cookie] = "set"
    redirect_to :back
  end

  skip_before_filter :verify_authenticity_token, only: [:loadkv,:savekv]

  def store_location
    Rails.logger.info params[:controller]
    unless request.xhr? || params[:controller].match(/devise|session/) || request.format == :json
      Rails.logger.info "STORED LOCATION"
      session[:user_return_to] = request.fullpath
    end
  end

  def authenticate_admin!
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
    unless user_signed_in? && (current_user.admin? || current_user.trailblazer? || current_user.baynature_trailblazer?)
      flash[:alert] = "Please login as a Trail Blazer to access that page."
      redirect_to '/embed/sessions/new' # halts request cycle
    end
  end

  def embed_authenticate_admin!
    unless user_signed_in? && (current_user.admin? || current_user.baynature_admin?)
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
    Rails.logger.info("loadkv : key = #{params[:key]} value = #{session[params[:key]]}")
    render :json => {:key=>params[:key],:value=>(session[params[:key]] || nil)}
  end

  def savekv
    Rails.logger.info("savekv : key = #{params[:key]} value = #{params[:value]}")
    session[params[:key]] = params[:value]
    render :json => {:key=>params[:key],:value=>params[:value]}
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
    session.delete("user_return_to")
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

  def page_not_found
    render "shared/page_not_found"
  end

  def send_contact
    if params[:from].blank?
      flash[:error] = "Please provide your email address so we can get back to you."
      redirect_to :back
    elsif
      !verify_recaptcha
      flash[:error] = "Sorry, we couldn't verify that you aren't a spambot."
      redirect_to :back
    else
      if Rails.env.production?
        Pony.mail(:to=>"contact@transitandtrails.org",:subject=>"Transit & Trails Contact Form",:from=>params[:from],:body=>params[:message])
      end
      flash[:notice] = "Thanks for the message! We'll get back to you as soon as we can."
      redirect_to :back
    end
  end

  def landing
    featured = TripFeature.find_by_name('Featured')
    @featured_trips = (featured && featured.trips.limit(3)) || Trip.order('id desc').limit(3)

    render :layout => "landing"
  end

end
