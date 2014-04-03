namespace :data do
  
  desc "Import OTDS Stewards"
  task :import_otds_stewards => :environment do
    response = Excon.get('http://www.outerspatial.com/otds/stewards.json')
    json = JSON.parse(response.body)
    json['stewards'].each do |item|
      agency = Agency.find_or_create_by_otds_id(item['id'])
      agency.update_attributes(
        name:item['name'],
        link:item['url'],
        description:"Address:\n#{item['address'].join('\n')}\n\nPhone:\n#{item['phone']}")        
      puts "Updated Agency ---"
      puts agency.to_json
    end
  end


  desc "Import OTDS Trailheads"
  task :import_otds_trailheads => :environment do
    response = Excon.get('http://www.outerspatial.com/otds/trailheads.json')
    json = JSON.parse(response.body)
    json['features'].each do |item|
      properties = item['properties']
      park = nil
      agency = nil
      agency_id = nil
      user_id = 1
      park_id = nil
      if properties['parkName'].present?
        park = Park.find_or_create_by_name("#{properties['parkName']}, Ohio")
        park_id = park.id
      end
      
      if item['properties']['stewardId'].any?
        sid = item['properties']['stewardId'][0]
        agency = Agency.find_by_otds_id(sid)
        
        if park
          park.update_attributes(agency_id:agency.id)
          if park.users.any?
            # user_id = park.users.first.id
          end
        else
          agency_id = agency.id
        end
      end

      trailhead = Trailhead.find_or_create_by_otds_id(properties['id'])
      trailhead.update_attributes(
        user_id:user_id,
        approved:true,
        park_id:park_id,
        agency_id:agency_id,
        name:properties['name'],
        longitude:item['geometry']['coordinates'][0],
        latitude:item['geometry']['coordinates'][1])
      puts "Updated Park ---"
      puts park.to_json
      puts "Updated Trailead ---"
      puts trailhead.to_json
    end
  end

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

  desc "Cache flickr urls"
  task :cache_flickr_urls => :environment do
    Photo.all.each do |photo|
      photo.cache_flickr_urls
      puts photo.save
    end
  end

  # desc "Approve all trailheads"
  # task :approve_trailheads => :environment do
  #   puts Trailhead.where(user_id: User.where(admin: true)).update_all(approved: true)
  #   puts Trailhead.where(user_id: User.where(trailblazer: true)).update_all(approved: true)
  #   puts "Done"
  # end

  desc "Cache parks on trailheads"
  task :cache_trailhead_parks => :environment do
    count = Park.count
    Trailhead.where(cached_park_by_bounds_id:nil).each_with_index do |t,i|
      t.park_by_bounds
      t.save
      puts "#{i+1}/#{count}"
    end
    puts "Done"
  end

  desc "Update park cached trailheads"
  task :update_cached_trailheads => :environment do
    count = Park.count
    Park.all.each_with_index do |p,i|
      p.update_cached_trailheads      
      puts "#{i+1}/#{count}"
    end
    puts "Done"
  end


  desc "Approve trailheads"
  task :approve_trailheads => :environment do
    puts "Approving trailheads"
    count = 0
    Trailhead.all.each do |t|
      t.save
      if t.approved
        count += 1
      end
    end
    puts "Done : #{count} approved"
  end

  desc "Destroy all campground_photos"
  task :destroy_campground_photos => :environment do
    puts "Destroying all campground photos"
    Photo.where(:photoable_type=>'Campground').destroy_all
    puts "Done"
  end

  desc "Cache parks on campgrounds"
  task :cache_campground_parks => :environment do
    count = Campground.count
    Campground.all.each_with_index do |t,i|
      t.save
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
