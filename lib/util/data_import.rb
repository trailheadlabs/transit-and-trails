module Util
  module DataImport
    def self.latest_user_objects
      remote_file = BAOSC_S3.directories.get('baosc-productiondatadump.auth.user').files.last
      local_file = File.open('/tmp/' + remote_file.key,'wb')
      local_file.write(remote_file.body)
      local_file.close
      reader = Zlib::GzipReader.new(open('/tmp/' + remote_file.key,'r'))
      json = JSON.parse(reader.read)
    end

    def self.latest_user_profile_objects
      remote_file = BAOSC_S3.directories.get('baosc-productiondatadump.tnt.userprofile').files.last
      local_file = File.open('/tmp/' + remote_file.key,'wb')
      local_file.write(remote_file.body)
      local_file.close
      reader = Zlib::GzipReader.new(open('/tmp/' + remote_file.key,'r'))
      json = JSON.parse(reader.read)
    end

  end
end
