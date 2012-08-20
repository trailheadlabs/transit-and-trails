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

    def self.import_user(item)
      if item['fields']['is_active']
        new_user = User.find_or_create_by_id(Integer(item['pk']))
        new_user.email = item['fields']['email']
        new_user.username = item['fields']['username']
        new_user.django_password = item['fields']['password']
        new_user.admin = item['fields']['is_superuser'] || item['fields']['is_staff']
        new_user.last_sign_in_at = item['fields']['last_login']
        new_user.created_at = item['fields']['date_joined']
        new_user.confirm!
        return new_user.save(:validate => false)
      else
        return false
      end
    end

    def self.import_user_profile(item)
      if User.exists? item['fields']['user']
        new_profile = UserProfile.find_or_create_by_id(item['pk'])
        new_profile.user_id = item['fields']['user']
        new_profile.firstname = item['fields']['first_name']
        new_profile.lastname = item['fields']['last_name']
        new_profile.address1 = item['fields']['address1']
        new_profile.address2 = item['fields']['address2']
        new_profile.city = item['fields']['city']
        new_profile.state = item['fields']['state']
        new_profile.zip = item['fields']['zip']
        new_profile.api_key = item['fields']['api_key']
        new_profile.api_secret = item['fields']['api_secret']
        new_profile.organization_name = item['fields']['organization_name']
        new_profile.signup_source = item['fields']['signup_source']
        new_profile.website_address = item['fields']['website_address']
        begin
          unless item['fields']['avatar'].blank?
            new_profile.remote_avatar_url = "http://transitandtrails.org/media/" + item['fields']['avatar']
            new_profile.avatar.store!
          end
        rescue Exception => e
          puts "Could not set avatar for user #{new_profile.user_id}"
          puts e.message
        end
        begin
          unless item['fields']['organization_avatar'].blank?
            new_profile.remote_organization_avatar_url = "http://transitandtrails.org/media/" + item['fields']['organization_avatar']
            new_profile.organization_avatar.store!
          end
        rescue Exception => e
          puts "Could not set organization avatar for user #{new_profile.user_id}"
          puts e.message
        end
        return new_profile.save
      else
        return false
      end
    end
  end
end
