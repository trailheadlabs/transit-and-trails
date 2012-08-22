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

    def self.import_agency(item)
      new_record = Agency.find_or_create_by_id(Integer(item['pk']))
      fields = item['fields']
      new_record.name = fields['name']
      new_record.description = fields['description']
      new_record.link = fields['link']

      begin
        unless fields['logo'].blank?
          new_record.remote_logo_url = "http://transitandtrails.org/media/" + fields['logo']
          new_record.logo.store!
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
          new_record.logo.store!
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
      new_record.save && new_record.trailhead_features = TrailheadFeature.where(id: fields['features'])
    end

    def self.import_feature(item)
      fields = item['fields']
      new_record = Feature.where(:name=>fields['name']).first_or_create
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
          new_record.marker_icon.store!
        end
      rescue Exception => e
        puts "Could not set marker icon for feature #{new_record.name}"
        puts fields['marker_icon']
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
          new_record.marker_icon.store!
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
