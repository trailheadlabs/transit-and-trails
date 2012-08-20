CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['AWS_KEY'],       # required
    :aws_secret_access_key  => ENV['AWS_SECRET'],       # required
  }
  config.fog_directory  = 'tntrailsuploads'                     # required
  config.fog_host       = 'https://tntrailsuploads.s3.amazonaws.com'            # optional, defaults to nil
end
