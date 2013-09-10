module Embed
  class CampgroundsController < ApplicationController
    def show
      @campground = Campground.find(params[:id])

      if params[:show]
        @show = params[:show].split(',')
      else
        @show = ['trails','description','contributor','summary','photos','map','attributes','actions','header','downloads','branding','nonprofit_partner']
      end

      if params[:hide]
        @hide = params[:hide].split(',')
        @show = @show - @hide
      end

      if params[:hide_title]
        @hide_title = params[:hide_title] == 'true'
      end

      if params[:hide_section_labels]
        @hide_section_labels = params[:hide_section_labels] == 'true'
      end

      if params[:full_description]
        @full_description = params[:full_description] == 'true'
      end

      render :layout => "embed/responsive"
    end

    def details
      @campground = Campground.find(params[:id])
      render "details", :layout => "embed"
    end
  end
end
