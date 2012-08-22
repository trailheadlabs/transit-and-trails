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

  desc "Import attribute_categories from the S3 backup"
  task :categories => :environment do
    # download file from S3
    json = Util::DataImport::latest_attribute_category_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_attribute_category item
    end
  end

  desc "Import features from the S3 backup"
  task :features => :environment do
    puts "importing trip features"
    # download file from S3
    json = Util::DataImport::latest_trip_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_feature item
    end

    puts "importing trailhead features"
    # download file from S3
    json = Util::DataImport::latest_trailhead_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_feature item
    end

    puts "importing campground features"
    # download file from S3
    json = Util::DataImport::latest_campground_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_feature item
    end

  end

  desc "Import campground features from the S3 backup"
  task :campground_features => :environment do

    puts "importing campground features"
    # download file from S3
    json = Util::DataImport::latest_campground_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_campground_feature item
    end

  end

  desc "Import trailhead features from the S3 backup"
  task :trailhead_features => :environment do

    puts "importing trailhead features"
    # download file from S3
    json = Util::DataImport::latest_trailhead_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_trailhead_feature item
    end

  end

  desc "Import trip features from the S3 backup"
  task :trip_features => :environment do

    puts "importing trip features"
    # download file from S3
    json = Util::DataImport::latest_trip_feature_objects
    # for each item in list
    json.each do |item|
      puts Util::DataImport::import_trip_feature item
    end

  end

end
