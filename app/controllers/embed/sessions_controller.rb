module Embed
  class SessionsController < ApplicationController
    def new
      render "new", :layout => "static_embed"
    end

  end
end
