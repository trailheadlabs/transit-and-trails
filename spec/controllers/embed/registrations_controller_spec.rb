require 'spec_helper'

describe Embed::RegistrationsController do
  render_views

  describe "GET 'confim'" do
    it "sends new trailblazer mail" do
      user = FactoryGirl.create(:user)
      User.should_receive(:confirm_by_token).and_return(user)
      mailer = double('mailer')
      mailer.stub(:deliver)
      Embed::RegistrationMailer.should_receive(:admin_registration_email).and_return(mailer)
      get :confirm, {:confirmation_token=>user.confirmation_token}
      response.should be_success
    end
  end
end
