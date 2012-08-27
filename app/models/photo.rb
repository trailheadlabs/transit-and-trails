class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :flickr_id, :image, :photoable_id, :photoable_type, :uploaded_to_flickr, :image_cache, :remote_image_url
  mount_uploader :image, PhotoUploader
  after_destroy :delete_from_flickr

  def delete_from_flickr
    flickr.photos.delete self.flickr_id
  end
end
