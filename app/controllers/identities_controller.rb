class IdentitiesController < ApplicationController
  before_filter :authenticate_user!
  def destroy
    @identity = current_user.identities.find(params[:id])
    name = @identity.provider.capitalize
    @identity.destroy

    respond_to do |format|
      flash[:notice] = "#{name} Disconnected"
      redirect_to :back || edit_user_path(current_user)
    end
  end
end
