if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false  end
  else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => ENV['AWS_KEY'],       # required
      :aws_secret_access_key  => ENV['AWS_SECRET'],       # required
    }
    config.fog_directory  = "tntrailsuploads-#{Rails.env}"                     # required
    config.fog_endpoint   = "https://tntrailsuploads-#{Rails.env}.s3.amazonaws.com"            # optional, defaults to nil
  end
end
