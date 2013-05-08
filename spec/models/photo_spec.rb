require 'spec_helper'

describe Photo do
  it "uploads to flickr" do
    flickr.should_receive(:upload_photo).and_return "12345678"
    t = FactoryGirl.create(:trip)
    p = FactoryGirl.build(:photo, :photoable_type=>"Trip",:photoable_id=>t.id)
    p.remote_image_url = "http://transitandtrails.org/media/baosc.png"
    p.save
    p.flickr_id.should eq "12345678"
  end

  it "deletes from flickr" do
    p = FactoryGirl.create(:photo,:flickr_id => "12345678")
    flickr.photos.should_receive(:delete)
    p.destroy
  end

  it "caches flickr urls" do
    p = FactoryGirl.create(:photo,:flickr_id => "12345678")
    url_val = "http://someawesomeurl.com"
    p.should_receive(:flickr_image_url).and_return(url_val)
    url = p.flickr_thumbnail_url
    p.flickr_urls.should_not be_nil
    p.flickr_urls[:thumbnail].should eq url_val
    url.should eq url_val
  end
end
