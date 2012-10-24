module Embed
  class TrailheadsController < ApplicationController
    def details
      @trailhead = Trailhead.find(params[:id])
      render "details", :layout => "embed"
    end

    def destroy
      sign_out
      redirect_to embed_signin_path
    end
  end
end
