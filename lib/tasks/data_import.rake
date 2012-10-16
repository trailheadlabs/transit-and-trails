require "util/data_import"

namespace :import do
  namespace :users do
    desc "Import user accounts from the S3 backup"
    task :accounts => :environment do
      Util::DataImport::import_items(Util::DataImport::latest_user_objects,"latest_user_objects")
      json = Util::DataImport::latest_user_objects
    end

    desc "Import a user account from the S3 backup"
    task :account, [:username] => [:environment] do |t, args|
      puts "#{args}"
      # download file from S3
      json = Util::DataImport::latest_user_objects
      user = json.select {|v| v['fields']['username'] == args[:username] }
      puts user[0].to_json
      if user
        puts JSON.pretty_generate item, :indent => "  "
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
      if profile[0]
        puts Util::DataImport::import_user_profile profile[0]
      else
        puts "User profile for #{:id} not found"
      end
    end

    desc "Import user profiles from the S3 backup"
    task :profiles => :environment do
      puts "importing user profiles"
      Util::DataImport::import_items(Util::DataImport::latest_user_profile_objects,"import_user_profile")
    end
  end

  desc "Import attribute_categories from the S3 backup"
  task :categories => :environment do
    puts "importing attribute categories"
    Util::DataImport::import_items(Util::DataImport::latest_attribute_category_objects,"import_attribute_category")
  end

  desc "Import features from the S3 backup"
  task :features => :environment do
    puts "importing trip features"
    Util::DataImport::import_items(Util::DataImport::latest_trip_feature_objects,"import_feature")    

    puts "importing trailhead features"
    Util::DataImport::import_items(Util::DataImport::latest_trailhead_feature_objects,"import_feature")

    puts "importing campground features"
    Util::DataImport::import_items(Util::DataImport::latest_campground_feature_objects,"import_feature")
  end

  desc "Import campground features from the S3 backup"
  task :campground_features => :environment do
    puts "importing campground features"
    Util::DataImport::import_items(Util::DataImport::latest_campground_feature_objects,"import_campground_feature")
  end

  desc "Import trailhead features from the S3 backup"
  task :trailhead_features => :environment do
    puts "importing trailhead features"
    Util::DataImport::import_items(Util::DataImport::latest_trailhead_feature_objects,"import_trailhead_feature")
  end

  desc "Import trip features from the S3 backup"
  task :trip_features => :environment do
    puts "importing trip features"
    Util::DataImport::import_items(Util::DataImport::latest_trip_feature_objects,"import_trip_feature")
  end

  desc "Import trailheads from the S3 backup"
  task :trailheads => :environment do
    puts "importing trailheads"
    Util::DataImport::import_items(Util::DataImport::latest_trailhead_objects,"import_trailhead")
  end

  desc "Import parks from the S3 backup"
  task :parks => :environment do
    puts "importing parks"
    Util::DataImport::import_items(Util::DataImport::latest_park_objects,"import_park")
  end

  desc "Import non profit partners from the S3 backup"
  task :non_profit_partners => :environment do
    puts "importing non profit partners"
    Util::DataImport::import_items(Util::DataImport::latest_non_profit_partner_objects,"import_non_profit_partner")
  end

  desc "Import agencies from the S3 backup"
  task :agencies => :environment do
    puts "importing agencies"
    Util::DataImport::import_items(Util::DataImport::latest_agency_objects,"import_agency")
  end

  desc "Import partners from the S3 backup"
  task :partners => :environment do
    puts "importing partners"
    Util::DataImport::import_items(Util::DataImport::latest_partner_objects,"import_partner")
  end

  desc "Import recent activity from the S3 backup"
  task :recent_activity => :environment do
    puts "importing recent activity"
    Util::DataImport::import_items(Util::DataImport::latest_recent_activity_objects,"import_recent_activity")
  end

  desc "Import campgrounds from the S3 backup"
  task :campgrounds => :environment do
    puts "importing campgrounds"
    Util::DataImport::import_items(Util::DataImport::latest_campground_objects,"import_campground")
  end

  desc "Import campground maps from the S3 backup"
  task :campground_maps => :environment do
    puts "importing campground maps"
    Util::DataImport::import_items(Util::DataImport::latest_campground_map_objects,"import_campground_map")
  end

  desc "Import trailhead maps from the S3 backup"
  task :trailhead_maps => :environment do
    puts "importing trailhead maps"
    Util::DataImport::import_items(Util::DataImport::latest_trailhead_map_objects,"import_trailhead_map")
  end

  desc "Import trip maps from the S3 backup"
  task :trip_maps => :environment do
    puts "importing trip maps"
    Util::DataImport::import_items(Util::DataImport::latest_trip_map_objects,"import_trip_map")
  end

  desc "Import trips from the S3 backup"
  task :trips => :environment do
    puts "importing trips"
    Util::DataImport::import_items(Util::DataImport::latest_trip_objects,"import_trip")
  end

  desc "Import stories from the S3 backup"
  task :stories => :environment do
    puts "importing stories"
    Util::DataImport::import_items(Util::DataImport::latest_story_objects,"import_story")
  end

  desc "Import regional landing pages from the S3 backup"
  task :regional_landing_pages => :environment do
    puts "importing regional landing pages"
    Util::DataImport::import_items(Util::DataImport::latest_regional_landing_page_objects,"import_regional_landing_page")
  end

  desc "Import campground photos from the S3 backup"
  task :campground_photos => :environment do
    puts "importing campground photos"
    Util::DataImport::import_items(Util::DataImport::latest_campground_photo_objects,"import_campground_photo")
  end

  desc "Import trailhead photos from the S3 backup"
  task :trailhead_photos => :environment do

    puts "importing trailhead photos"
    Util::DataImport::import_items(Util::DataImport::latest_trailhead_photo_objects,"import_trailhead_photo")
  end

  desc "Import trip photos from the S3 backup"
  task :trip_photos => :environment do
    puts "importing trip photos"
    Util::DataImport::import_items(Util::DataImport::latest_trip_photo_objects,"import_trip_photo")
  end

  desc "Import feature tabs from the S3 backup"
  task :featured_tabs => :environment do
    puts "importing featured tabs"
    Util::DataImport::import_items(Util::DataImport::latest_featured_tab_objects,"import_featured_tab")
  end

  desc "Import transit agencies from the S3 backup"
  task :transit_agencies => :environment do
    puts "importing transit agencies"
    Util::DataImport::import_items(Util::DataImport::latest_transit_agency_objects,"import_transit_agency")
  end

  desc "Import transit routers from the S3 backup"
  task :transit_routers => :environment do
    puts "importing transit routers"
    Util::DataImport::import_items(Util::DataImport::latest_transit_router_objects,"import_transit_router")
  end

  desc "Turn off paper trail"
  task :paper_trail_off => :environment do
    PaperTrail.enabled = false
  end

  desc "Import all objects from the S3 backup"
  task :all => [
      "paper_trail_off",
      "users:accounts",
      "users:profiles",
      "categories",
      "campground_features",
      "trailhead_features",
      "trip_features",
      "trailheads",
      "campgrounds",
      "trips",
      "campground_photos",
      "trailhead_photos",
      "trip_photos",
      "campground_maps",
      "trailhead_maps",
      "trip_maps",
      "stories",
      "non_profit_partners",
      "agencies",
      "partners",
      "recent_activity",
      "featured_tabs",
      "transit_agencies",
      "transit_routers",
      "parks",
      "regional_landing_pages"]

end
