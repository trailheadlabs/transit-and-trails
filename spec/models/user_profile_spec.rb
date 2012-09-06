require 'spec_helper'

describe UserProfile do
  it "sets url" do
    u = UserProfile.new
    u.url = "http://example.com"
    u.url.should eq "http://example.com"
  end

  it "generates api key" do
    u = UserProfile.create
    u.api_key.should_not be_blank
    u.api_key.length.should be > 12
    u.api_secret.should_not be_blank
    u.api_secret.length.should be > 12
  end

end
