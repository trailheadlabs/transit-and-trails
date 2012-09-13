namespace :data do

  desc "Import a user account from the S3 backup"
  task :reset_all_autoincrements, [:value] => [:environment] do |t, args|
    value = Integer(args[:value])
    [User,UserProfile,Trailhead,Trip,Campground,Park].each do |m|
      m.reset_autoincrement(to: value)
    end
    puts "Done"
  end

end
