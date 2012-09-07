class PhotosController < ApplicationController
  # POST /photos
  # POST /photos.json
  def create
    Rails.logger.info "in create"
    @photo = Photo.new(params[:photo])
    @photo.user = current_user
    Rails.logger.info @photo.to_json

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo.photoable, notice: 'Photo added!' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
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
      format.html { redirect_to @photo.photoable }
      format.json { head :no_content }
    end
  end

end
