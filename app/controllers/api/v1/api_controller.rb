module Api
  module V1
    class ApiController < ApplicationController
      before_filter :valid_api_key!

    end
  end
end
