class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.user = current_user

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to :back || @favorite.favorable, notice: 'Favorite added!' }
        format.json { render json: @favorite, status: :created, location: @favorite }
      else
        format.html { redirect_to :back }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_to :back || @favorite.favorable, notice: 'Favorite removed!' }
      format.json { head :no_content }
    end
  end


end
