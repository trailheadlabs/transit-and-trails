require "spec_helper"

describe ApplicationController do
  controller do
    def index
      authenticate_admin!
    end
  end

  describe "handling AccessDenied exceptions" do
    it "redirects to the sign in page" do
      get :index
      response.should redirect_to("/users/sign_in")
    end
  end

end
