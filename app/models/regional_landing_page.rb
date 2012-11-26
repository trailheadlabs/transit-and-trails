class RegionalLandingPage < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude, :name, :path

  rails_admin do

    edit do
      field :name
      field :description
      field :path
      field :longitude, :hidden
      field :latitude, :map do
        longitude_field :longitude
        google_api_key "AIzaSyCcUhpQftpOwXVSLJqHrvwYCqnhTy3bchE"
        default_latitude 37.7750
        default_longitude -122.4190
      end

    end
  end

end
