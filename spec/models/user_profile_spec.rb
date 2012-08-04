require 'spec_helper'

describe UserProfile do
  it "sets url" do
    u = UserProfile.new
    u.url = "http://example.com"
    u.url.should eq "http://example.com"
  end
end
