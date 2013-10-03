class IdentitiesController < ApplicationController
  before_filter :authenticate_user!
  def destroy
    @identity = current_user.identities.find(params[:id])
    name = @identity.provider.capitalize
    @identity.destroy

    redirect_to :back || edit_user_path(current_user), :notice => "#{name} Disconnected"
    end
  end
end
