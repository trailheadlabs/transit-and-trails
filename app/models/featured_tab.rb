class FeaturedTab < ActiveRecord::Base
  attr_accessible :header, :highlighted, :image, :image_link, :link1,
    :link1_text, :link2, :link2_text, :link3, :link3_text, :link4, :link4_text,
    :link5, :link5_text, :text1, :text2, :text3, :image_cache, :remote_image_url

  mount_uploader :image, FeaturedTabImageUploader
end
