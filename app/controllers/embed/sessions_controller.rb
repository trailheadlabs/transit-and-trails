module Embed
  class SessionsController < ApplicationController
    skip_before_filter :verify_authenticity_token
    def new
      render "new", :layout => "static_embed"
    end

    def destroy
      sign_out
      redirect_to embed_signin_path
    end
  end
end
