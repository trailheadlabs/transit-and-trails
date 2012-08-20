S3 = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => ENV['AWS_KEY'],
  :aws_secret_access_key    => ENV['AWS_SECRET']
})

BAOSC_S3 = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => ENV['BAOSC_AWS_KEY'],
  :aws_secret_access_key    => ENV['BAOSC_AWS_SECRET']
})
