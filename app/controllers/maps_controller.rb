class MapsController < ApplicationController
  before_filter :authenticate_user!

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(params[:map])
    @map.user = current_user


    respond_to do |format|
      if @map.save
        format.html { redirect_to request.env["HTTP_REFERER"] || @map.mapable, notice: 'Map added!' }
        format.json { render json: @map, status: :created, location: @map }
      else
        format.html { redirect_to request.env["HTTP_REFERER"] }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    @map = Map.find(params[:id])
    @map.destroy

    respond_to do |format|
      format.html { redirect_to request.env["HTTP_REFERER"] || @map.mapable, notice: 'Map removed!' }
      format.json { head :no_content }
    end
  end

end
