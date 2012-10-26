module Embed
  class TrailheadsController < ApplicationController
    def details
      @trailhead = Trailhead.find(params[:id])
      render "details", :layout => "embed"
    end

  end
end
