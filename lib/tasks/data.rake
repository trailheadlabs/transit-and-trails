namespace :data do

  desc "Reset autoincrements"
  task :reset_all_autoincrements, [:value] => [:environment] do |t, args|
    [ 
      Agency,
      Campground,
      CampgroundFeature,
      Category,
      Duration,
      FeaturedTab,
      Intensity,
      Map,
      NonProfitPartner,
      Park,
      Partner,
      Photo,
      RecentActivity,
      RegionalLandingPage,
      Story,
      Trailhead,
      TrailheadFeature,
      TransitAgency,
      TravelMode,
      Trip,
      TripFeature,
      User,
      UserProfile
    ].each do |m|
      value = m.order('id').last.id + 1000
      puts "Reseting #{m.name} to #{value}"
      m.reset_autoincrement(to: value)
    end
    puts "Done"
  end

  desc "Approve all campgrounds"
  task :approve_all_campgrounds => :environment do
    Campground.update_all(approved: true)
    puts "Done"
  end

  desc "Cache parks on trailheads"
  task :cache_trailhead_parks => :environment do
    count = Trailhead.count
    Trailhead.all.each_with_index do |t,i|
      t.default_park
      puts "#{i+1}/#{count}"
    end
    puts "Done"
  end


  desc "Cache parks on campgrounds"
  task :cache_campground_parks => :environment do
    count = Campground.count
    Campground.all.each_with_index do |t,i|
      t.default_park
      puts "#{i+1}/#{count}"
    end
    puts "Done"
  end

  desc "Run all data tasks"
  task :all => ["reset_all_autoincrements",
                "approve_all_campgrounds",
                "cache_trailhead_parks",
                "cache_campground_parks"]

end
