require "util/data_import"

namespace :import do
  namespace :users do
    desc "Import user accounts from the S3 backup"
    task :accounts => :environment do
      # download file from S3
      json = Util::DataImport::latest_user_objects
      # parse json
      # for each item in list
      json.each do |item|
        puts Util::DataImport::import_user item
      end

    end

    desc "Import a user account from the S3 backup"
    task :account, [:username] => [:environment] do |t, args|
      puts "#{args}"
      # download file from S3
      json = Util::DataImport::latest_user_objects
      user = json.select {|v| v['fields']['username'] == args[:username] }
      puts user[0].to_json
      if user
        puts Util::DataImport::import_user user[0]
      else
        puts "User #{:username} not found"
      end
    end


    desc "Import a user profile from the S3 backup"
    task :profile, [:id] => [:environment] do |t, args|
      puts "#{args}"
      # download file from S3
      json = Util::DataImport::latest_user_profile_objects
      profile = json.select {|v| v['fields']['user'] == Integer(args[:id]) }
      puts profile[0].to_json
      if profile[0]
        puts Util::DataImport::import_user_profile profile[0]
      else
        puts "User profile for #{:id} not found"
      end
    end

    desc "Import user profiles from the S3 backup"
    task :profiles => :environment do
      # download file from S3
      json = Util::DataImport::latest_user_profile_objects
      # for each item in list
      json.each do |item|
        puts Util::DataImport::import_user_profile item
      end
    end

  end
end
