require "util/data_import"

namespace :users do
  desc "Import user accounts from the S3 backup"
  task :accounts => :environment do
    # download file from S3
    json = Util::DataImport::latest_user_objects
    # parse json
    # for each item in list
    json.each do |item|
      if item['fields']['is_active']
        new_user = User.find_or_create_by_id(Integer(item['pk']))
        new_user.email = item['fields']['email']
        new_user.username = item['fields']['username']
        new_user.django_password = item['fields']['password']
        new_user.admin = item['fields']['is_superuser'] || item['fields']['is_staff']
        new_user.last_sign_in_at = item['fields']['last_login']
        new_user.created_at = item['fields']['date_joined']
        puts new_user.save(:validate => false)
      else
        puts "not active"
      end
    end
  end

desc "Import user profiles from the S3 backup"
  task :profiles => :environment do
    # download file from S3
    json = Util::DataImport::latest_user_profile_objects
    # for each item in list
    json.each do |item|
      if User.exists? item['pk']
        new_profile = UserProfile.find_or_create_by_id(item['pk'])
        new_profile.user_id = item['fields']['user']
        new_profile.firstname = item['fields']['first_name']
        new_profile.lastname = item['fields']['last_name']
        new_profile.address1 = item['fields']['address1']
        new_profile.address2 = item['fields']['address2']
        new_profile.city = item['fields']['city']
        new_profile.state = item['fields']['state']
        new_profile.zip = item['fields']['zip']
        puts new_profile.save
      else
        puts "no user"
      end
    end
  end

end
