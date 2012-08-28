class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :flickr_id, :image, :photoable_id, :photoable_type, :uploaded_to_flickr, :image_cache, :remote_image_url
  mount_uploader :image, PhotoUploader
  after_destroy :delete_from_flickr

  def delete_from_flickr
    begin
      flickr.photos.delete :photo_id => self.flickr_id
    rescue Exception => e
      Rails.logger.error e
    end
  end

  # http://www.flickr.com/services/api/misc.urls.html
  def flickr_info
    flickr.photos.getInfo :photo_id => self.flickr_id
  end

  # eventually we should just cache all of these on the model
  def flickr_url
    "http://flickr.com/#{flickr.test.login.username}/#{flickr_id}"
  end

  def flickr_thumbnail_url
    FlickRaw.url_t(flickr_info)
  rescue
    nil
  end

  def flickr_square_url
    FlickRaw.url_s(flickr_info)
  rescue
    nil
  end

  def flickr_medium_url
    FlickRaw.url_z(flickr_info)
  rescue
    nil
  end

  def flickr_original_url
    FlickRaw.url_o(flickr_info)
  rescue
    nil
  end

  def flickr_large_url
    FlickRaw.url_b(flickr_info)
  rescue
    nil
  end

end
