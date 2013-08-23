module Embed
  class TrailheadsController < ApplicationController
    def show
      details
    end

    def details
      @trailhead = Trailhead.find(params[:id])
      render "details", :layout => "embed"
    end

  end
end
