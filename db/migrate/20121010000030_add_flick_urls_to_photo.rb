class AddFlickUrlsToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :flickr_urls, :text
  end
end
