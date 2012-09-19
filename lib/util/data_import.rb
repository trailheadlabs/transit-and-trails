module Util
  module DataImport
    def self.latest_objects_for(bucket)
      remote_file = BAOSC_S3.directories.get(bucket).files.last
      local_file = File.open('/tmp/' + remote_file.key,'wb')
      local_file.write(remote_file.body)
      local_file.close
      reader = Zlib::GzipReader.new(open('/tmp/' + remote_file.key,'r'))
      json = JSON.parse(reader.read)
    end

    def self.latest_user_objects
      latest_objects_for('baosc-productiondatadump.auth.user')
    end

    def self.latest_user_profile_objects
      latest_objects_for('baosc-productiondatadump.tnt.userprofile')
    end

    def self.latest_attribute_category_objects
      latest_objects_for('baosc-productiondatadump.tnt.attributecategory')
    end

    def self.latest_trip_feature_objects
      latest_objects_for('baosc-productiondatadump.tnt.tripfeature')
    end

    def self.latest_trailhead_feature_objects
      latest_objects_for('baosc-productiondatadump.tnt.trailheadfeature')
    end

    def self.latest_campground_feature_objects
      latest_objects_for('baosc-productiondatadump.tnt.campgroundfeature')
    end

    def self.latest_trailhead_objects
      latest_objects_for('baosc-productiondatadump.tnt.trailhead')
    end

    def self.latest_park_objects
      latest_objects_for('baosc-productiondatadump.tnt.park')
    end

    def self.latest_non_profit_partner_objects
      latest_objects_for('baosc-productiondatadump.tnt.nonprofitpartner')
    end

    def self.latest_agency_objects
      latest_objects_for('baosc-productiondatadump.tnt.agency')
    end

    def self.latest_partner_objects
      latest_objects_for('baosc-productiondatadump.tnt.partner')
    end

    def self.latest_recent_activity_objects
      latest_objects_for('baosc-productiondatadump.tnt.recentactivity')
    end

    def self.latest_campground_objects
      latest_objects_for('baosc-productiondatadump.tnt.campground')
    end

    def self.latest_campground_map_objects
      latest_objects_for('baosc-productiondatadump.tnt.campgroundmap')
    end

    def self.latest_trailhead_map_objects
      latest_objects_for('baosc-productiondatadump.tnt.trailheadmap')
    end

    def self.latest_trip_map_objects
      latest_objects_for('baosc-productiondatadump.tnt.tripmap')
    end

    def self.latest_trip_objects
      latest_objects_for('baosc-productiondatadump.tnt.trip')
    end

    def self.latest_story_objects
      latest_objects_for('baosc-productiondatadump.tnt.story')
    end

    def self.latest_regional_landing_page_objects
      latest_objects_for('baosc-productiondatadump.tnt.regionallandingpage')
    end

    def self.latest_campground_photo_objects
      latest_objects_for('baosc-productiondatadump.tnt.campgroundphoto')
    end

    def self.latest_trailhead_photo_objects
      latest_objects_for('baosc-productiondatadump.tnt.trailheadphoto')
    end

    def self.latest_trip_photo_objects
      latest_objects_for('baosc-productiondatadump.tnt.tripphoto')
      response = HTTParty.get('http://transitandtrails.org/api/v1/trip_photos')
      JSON.parse(response.body)
    end

    def self.latest_featured_tab_objects
      latest_objects_for('baosc-productiondatadump.tnt.featuredtab')
    end

    def self.latest_transit_agency_objects
      latest_objects_for('baosc-productiondatadump.tnt.transitagency')
    end

    def self.latest_transit_router_objects
      latest_objects_for('baosc-productiondatadump.tnt.transitrouter')
    end

    def self.import_regional_landing_page(item)
      new_record = RegionalLandingPage.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.path = fields['path']
      map_center = fields['map_center'].gsub(/[A-Za-z]|\(|\)/,"").strip.split(',').collect{|c| c.split(" ").collect{|d| Float(d)}}
      new_record.longitude = map_center[0][0]
      new_record.latitude = map_center[0][1]
      new_record.save
    end

    def self.import_transit_agency(item)
      new_record = TransitAgency.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['agency']
      new_record.web = fields['web']
      new_record.geometry = fields['geom']
      new_record.save
    end

    def self.import_transit_router(item)
      new_record = TransitRouter.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.transit_agencies = TransitAgency.where(id: fields['agencies'])
      new_record.save
    end

    def self.import_story(item)
      intensities = {1=>"Easy",2=>"Moderate",3=>"Strenuous"}
      new_record = Story.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.story = fields['story']
      new_record.happened_at = fields['happened_at']
      new_record.to_travel_mode = TravelMode.find_by_name(fields['travel_mode_to'].downcase.capitalize)
      new_record.from_travel_mode = TravelMode.find_by_name(fields['travel_mode_from'].downcase.capitalize)
      new_record.user_id = fields['author']
      new_record.storytellable_id = fields['object_id']
      new_record.storytellable_type = "Trip"
      new_record.save
    end

    def self.import_trip(item)
      intensities = {1=>"Easy",2=>"Moderate",3=>"Strenuous"}
      new_record = Trip.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.intensity = Intensity.find_by_name(intensities[fields['intensity']])
      new_record.duration = Duration.find_by_name(fields['duration'])
      new_record.starting_trailhead_id = fields['starting_point']
      new_record.ending_trailhead_id = fields['ending_point']
      new_record.user_id = fields['author']
      new_record.route = fields['route']
      new_record.geometry = fields['geom']
      new_record.trip_features = TripFeature.where(id: fields['features'])
      new_record.save
    end

    def self.import_recent_activity(item)
      new_record = RecentActivity.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.highlighted = fields['highlighted']
      new_record.recent_news_text = fields['recent_news_text']

      new_record.favorites_link1 = fields['favorites_link1']
      new_record.favorites_type1 = fields['favorites_type1']
      new_record.favorites_link1_text = fields['favorites_link1_text']

      new_record.favorites_link2 = fields['favorites_link2']
      new_record.favorites_type2 = fields['favorites_type2']
      new_record.favorites_link2_text = fields['favorites_link2_text']

      new_record.favorites_link3 = fields['favorites_link3']
      new_record.favorites_type3 = fields['favorites_type3']
      new_record.favorites_link3_text = fields['favorites_link3_text']

      new_record.favorites_link4 = fields['favorites_link4']
      new_record.favorites_type4 = fields['favorites_type4']
      new_record.favorites_link4_text = fields['favorites_link4_text']

      new_record.favorites_link5 = fields['favorites_link5']
      new_record.favorites_type5 = fields['favorites_type5']
      new_record.favorites_link5_text = fields['favorites_link5_text']

      new_record.save
    end

    def self.import_featured_tab(item)
      new_record = FeaturedTab.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.header = fields['header']
      new_record.highlighted = fields['highlighted']
      new_record.text1 = fields['text1']
      new_record.text2 = fields['text2']
      new_record.text3 = fields['text3']

      begin
        unless fields['image'].blank?
          new_record.remote_image_url = "http://transitandtrails.org/media/" + fields['image']
          # new_record.image.store!
        end
      rescue Exception => e
        puts "Could not set image for partner #{new_record.header}"
        puts fields['image']
        puts e.message
      end

      new_record.image_link

      new_record.link1 = fields['link1']
      new_record.link1_text = fields['link1_text']

      new_record.link2 = fields['link2']
      new_record.link2_text = fields['link2_text']

      new_record.link3 = fields['link3']
      new_record.link3_text = fields['link3_text']

      new_record.link4 = fields['link4']
      new_record.link4_text = fields['link4_text']

      new_record.link5 = fields['link5']
      new_record.link5_text = fields['link5_text']
      new_record.save
  end


    def self.import_partner(item)
      new_record = Partner.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.link = fields['link']

      begin
        unless fields['logo'].blank?
          new_record.remote_logo_url = "http://transitandtrails.org/media/" + fields['logo']
          # new_record.logo.store!
        end
      rescue Exception => e
        puts "Could not set logo for partner #{new_record.name}"
        puts fields['logo']
        puts e.message
      end
      new_record.save
    end

    def self.import_agency(item)
      new_record = Agency.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.link = fields['link']

      begin
        unless fields['logo'].blank?
          new_record.remote_logo_url = "http://transitandtrails.org/media/" + fields['logo']
          # new_record.logo.store!
        end
      rescue Exception => e
        puts "Could not set logo for non profit partner #{new_record.name}"
        puts fields['logo']
        puts e.message
      end
      new_record.save
    end

    def self.import_non_profit_partner(item)
      new_record = NonProfitPartner.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.link = fields['link']

      begin
        unless fields['logo'].blank?
          new_record.remote_logo_url = "http://transitandtrails.org/media/" + fields['logo']
          # new_record.logo.store!
        end
      rescue Exception => e
        puts "Could not set logo for non profit partner #{new_record.name}"
        puts fields['logo']
        puts e.message
      end
      new_record.save
    end

    def self.import_park(item)
      new_record = Park.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.agency_id = fields['agency']
      new_record.acres = fields['acres']
      new_record.county = fields['county']
      new_record.county_slug = fields['county_slug']
      new_record.slug = fields['slug']
      new_record.link = fields['link']
      new_record.bounds = fields['geom']
      new_record.non_profit_partner_id = fields['non_profit_partner']
      new_record.save
    end

    def self.import_attribute_category(item)
      new_record = Category.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.rank = fields['rank']
      new_record.visible = fields['visible']
      new_record.save
    end

    def self.import_trailhead(item)
      new_record = Trailhead.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.rideshare = fields['rideshare']
      new_record.latitude = fields['latitude']
      new_record.longitude = fields['longitude']
      new_record.zimride_url = fields['zimride_url']
      new_record.user_id = fields['author']
      new_record.approved = fields['approved']
      new_record.park_id = fields['park']
      new_record.trailhead_features = TrailheadFeature.where(id: fields['features'])
      new_record.save
    end

    def self.import_campground(item)
      new_record = Campground.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.latitude = fields['latitude']
      new_record.longitude = fields['longitude']
      new_record.user_id = fields['author']
      new_record.approved = fields['approved']
      new_record.park_id = fields['park']
      new_record.campground_features = CampgroundFeature.where(id: fields['features'])
      new_record.save
    end

    def self.import_campground_map(item)
      new_record = Map.new
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.user_id = fields['user']
      new_record.url = fields['url']
      new_record.mapable_id = fields['campground']
      new_record.mapable_type = "Campground"
      begin
        unless fields['map'].blank?
          new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
        end
      rescue Exception => e
        puts "Could not set map for campground #{new_record.name}"
        puts fields['map']
        puts e.message
      end
      new_record.save
    end

    def self.import_campground_photo(item)
      new_record = Photo.new
      fields = item['fields']
      new_record.flickr_id = fields['flickr_id']
      new_record.uploaded_to_flickr = fields['uploaded_to_flickr']
      new_record.user_id = fields['user']
      new_record.photoable_id = fields['campground']
      new_record.photoable_type = "Campground"
      # begin
      #   unless fields['map'].blank?
      #     new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
      #     new_record.map.store!
      #   end
      # rescue Exception => e
      #   puts "Could not set map for campground #{new_record.name}"
      #   puts fields['map']
      #   puts e.message
      # end
      new_record.save
    end

    def self.import_trailhead_photo(item)
      new_record = Photo.new
      fields = item['fields']
      new_record.flickr_id = fields['flickr_id']
      new_record.uploaded_to_flickr = fields['uploaded_to_flickr']
      new_record.user_id = fields['user']
      new_record.photoable_id = fields['trailhead']
      new_record.photoable_type = "Trailhead"
      # begin
      #   unless fields['map'].blank?
      #     new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
      #     new_record.map.store!
      #   end
      # rescue Exception => e
      #   puts "Could not set map for campground #{new_record.name}"
      #   puts fields['map']
      #   puts e.message
      # end
      new_record.save
    end

    def self.import_trip_photo(item)
      new_record = Photo.new
      fields = item
      new_record.flickr_id = fields['flickr_id']
      new_record.uploaded_to_flickr = fields['uploaded_to_flickr']
      new_record.user_id = fields['user']
      new_record.photoable_id = fields['trip']
      new_record.photoable_type = "Trip"
      # begin
      #   unless fields['map'].blank?
      #     new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
      #     new_record.map.store!
      #   end
      # rescue Exception => e
      #   puts "Could not set map for campground #{new_record.name}"
      #   puts fields['map']
      #   puts e.message
      # end
      new_record.save
    end

    def self.import_trip_map(item)
      new_record = Map.new
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.user_id = fields['user']
      new_record.url = fields['url']
      new_record.mapable_id = fields['trip']
      new_record.mapable_type = "Trip"
      begin
        unless fields['map'].blank?
          new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
        end
      rescue Exception => e
        puts "Could not set map for trip #{new_record.name}"
        puts fields['map']
        puts e.message
      end
      new_record.save
    end

    def self.import_trailhead_map(item)
      new_record = Map.new
      fields = item['fields']
      new_record.url = fields['map_url']
      new_record.mapable_id = fields['trailhead']
      new_record.mapable_type = "Trailhead"
      begin
        unless fields['map'].blank?
          new_record.remote_map_url = "http://transitandtrails.org/media/" + fields['map']
        end
      rescue Exception => e
        puts "Could not set map for trailhead #{new_record.name}"
        puts fields['map']
        puts e.message
      end
      new_record.save
    end

    def self.import_campground_feature(item)
      fields = item['fields']
      new_record = CampgroundFeature.find_or_create_by_id(item['pk'])
      populate_feature(new_record,fields)
      new_record.save
    end

    def self.import_trip_feature(item)
      fields = item['fields']
      new_record = TripFeature.find_or_create_by_id(item['pk'])
      populate_feature(new_record,fields)
      new_record.save
    end

    def self.import_trailhead_feature(item)
      fields = item['fields']
      new_record = TrailheadFeature.find_or_create_by_id(item['pk'])
      populate_feature(new_record,fields)
      new_record.save
    end

    def self.populate_feature(new_record,fields)
      new_record.name = fields['name']
      new_record.description = fields['description']
      if new_record.rank
        new_record.rank = fields['rank'] if fields['rank'] > new_record.rank
      else
        new_record.rank = fields['rank']
      end
      new_record.category_id = fields['category']
      new_record.link_url = fields['link_url']
      begin
        unless fields['marker_icon'].blank?
          new_record.remote_marker_icon_url = "http://transitandtrails.org/media/" + fields['marker_icon']
          # new_record.marker_icon.store!
        end
      rescue Exception => e
        puts "Could not set marker icon for feature #{new_record.name}"
        puts fields['marker_icon']
        puts e.message
      end

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
      if User.exists? Integer(item['fields']['user'])
        new_profile = User.find(Integer(item['fields']['user'])).user_profile || UserProfile.new
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
            # new_profile.avatar.store!
          end
        rescue Exception => e
          puts "Could not set avatar for user #{new_profile.user_id}"
          puts e.message
        end
        begin
          unless item['fields']['organization_avatar'].blank?
            new_profile.remote_organization_avatar_url = "http://transitandtrails.org/media/" + item['fields']['organization_avatar']
            # new_profile.organization_avatar.store!
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
