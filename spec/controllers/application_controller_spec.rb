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

    it "redirects to the root for a regular user" do
      @user = FactoryGirl.create(:user)
      sign_in :user, @user
      controller.user_signed_in?.should be_true
      get :index
      response.should redirect_to("/")
    end
  end

end
