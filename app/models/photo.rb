class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :photoable, :polymorphic => true
  attr_accessible :flickr_id, :image, :photoable_id, :photoable_type, :uploaded_to_flickr, :image_cache, :remote_image_url
  mount_uploader :image, PhotoUploader
  after_destroy :delete_from_flickr
  serialize :flickr_urls, Hash
  before_save :cache_flickr_urls

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

  def cache_flickr_urls
    if(flickr_id_changed? || flickr_urls.nil?)
      fetch_flickr_sizes
    end    
  end

  def fetch_flickr_sizes
    sizes = flickr.photos.getSizes(photo_id: flickr_id)    
    sizes.each do |s|      
      token = s[:label].parameterize.underscore.to_sym
      flickr_urls[token] = s[:source]
    end
  end

  # eventually we should just cache all of these on the model
  def flickr_url
    "http://flickr.com/#{flickr.test.login.username}/#{flickr_id}"
  rescue
    nil
  end

  def flickr_image_url(size)
    if flickr_urls[size].nil?
      fetch_flickr_sizes      
      save
    end
    flickr_urls[size]
  rescue
    nil
  end

  def flickr_thumbnail_url
    flickr_image_url :thumbnail
  end

  def flickr_square_url
    flickr_image_url :square
  end

  def flickr_medium_url
    flickr_image_url :medium
  end

  def flickr_original_url
    flickr_image_url :original
  end

  def flickr_large_url
    flickr_image_url :large
  end

end
