require 'flickraw'

if Rails.env.test?
  FlickRaw.api_key="xxx"
  FlickRaw.shared_secret="yyy"

  begin
    flickr.access_token = "aaa"
    flickr.access_secret = "bbb"
  rescue
  end


else
  FlickRaw.api_key=ENV['FLICKR_KEY']
  FlickRaw.shared_secret=ENV['FLICKR_SECRET']

  begin
    flickr.access_token = ENV['FLICKR_ACCESS_TOKEN']
    flickr.access_secret = ENV['FLICKR_ACCESS_SECRET']
  rescue
  end
end
