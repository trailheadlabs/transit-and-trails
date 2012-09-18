namespace :data do

  desc "Reset autoincrements"
  task :reset_all_autoincrements, [:value] => [:environment] do |t, args|
    [User,UserProfile,Trailhead,Trip,Campground,Park,Agency,NonProfitPartner,
      Category,Duration,Intensity,Partner,RecentActivity,RegionalLandingPage,Story,
      TransitAgency,TransitRouter,FeaturedTab].each do |m|
      value = m.order('id').last.id + 1
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

end
