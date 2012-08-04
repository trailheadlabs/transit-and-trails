require 'spec_helper'

describe User do
  it "should login with django_password" do
    u = User.create
    u.email='test@user.com'
    u.username='testuser'
    u.django_password = 'sha1$69346$ded8d5952126f2a1a06218e619a6ffcd14b1bb70'
    u.skip_confirmation!
    u.save(:validate=>false)
    u.encrypted_password.should be_blank
    u.valid_password?('password').should be_true
    u.encrypted_password.should_not be_blank
    u.valid_password?('password').should be_true
  end

  it "should find by email" do
    u = FactoryGirl.create(:user)
    conditions = {:email => u.email}
    u.should eq User.find_first_by_auth_conditions(conditions)
  end
end
