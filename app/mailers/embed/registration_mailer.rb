class Embed::RegistrationMailer < ActionMailer::Base
  default from: "noreply@transitandtrails.org"

  def user_confirmation_email(user)
    @user = user
    mail(:to => user.email, :subject => "Transit & Trails Email Confirmation")
  end

  def user_approved_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Transit & Trails!")
  end

  def admin_registration_email(user)
    @user = user
    mail(:to => "me@jmoe.com", :subject => "New Bay Nature Trailblazer")
  end

end
