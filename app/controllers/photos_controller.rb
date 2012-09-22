class PhotosController < ApplicationController
  before_filter :authenticate_user!

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])
    @photo.user = current_user

    respond_to do |format|
      if @photo.save
        format.html { redirect_to request.env["HTTP_REFERER"] || @photo.photoable, notice: 'Photo added!' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { redirect_to request.env["HTTP_REFERER"] }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to request.env["HTTP_REFERER"] || @photo.photoable, notice: 'Photo removed!' }
      format.json { head :no_content }
    end
  end

end
