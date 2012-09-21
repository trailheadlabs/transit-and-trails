module Embed
  class SessionsController < ApplicationController
    def new
      render "new", :layout => "static_embed"
    end

    def destroy
      sign_out
      redirect_to embed_signin_path
    end
  end
end
