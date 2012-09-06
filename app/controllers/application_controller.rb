class ApplicationController < ActionController::Base
  protect_from_forgery
  helper TextHelper

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

end
