require 'spec_helper'
require 'util/data_import'

describe "DataImport" do
  before(:each) do
    Fog.mock!
  end

  it "downloads the latest attribute categories" do
    json = Util::DataImport::latest_attribute_category_objects
    json.count.should be > 0
  end

  it "imports attribute categories correctly" do
    item = JSON::parse('{"pk": 8, "model": "tnt.attributecategory", "fields": {"visible": true, "name": "Trip Route", "rank": 1, "description": "What is the trip route - loop, out and back, one-way?"}}')
    Util::DataImport::import_attribute_category item
    fields = item['fields']
    new_record = Category.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rank.should eq fields['rank']
    new_record.visible.should eq fields['visible']
  end

  it "imports transit agencies correctly" do
    item = JSON::parse('
      {
        "pk": 33,
        "model": "tnt.transitagency",
        "fields": {
          "web": "http://www.westcat.org/",
          "agency": "WestCAT",
          "_511": "http://transit.511.org/schedules/index.aspx",
          "geom": "MULTIPOLYGON (((-122.2431490217469729 38.0581689552289220, -122.2424359499600257 38.0581000117468875)))",
          "agncy_id": "WC",
          "type": "Bus"
        }
      }
      ')
    Util::DataImport::import_transit_agency item
    fields = item['fields']
    new_record = TransitAgency.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['agency']
    new_record.geometry.should eq fields['geom']
    new_record.web.should eq fields['web']
  end

  it "imports transit routers correctly" do
    FactoryGirl.create(:transit_agency,:id=>4)
    FactoryGirl.create(:transit_agency,:id=>7)
    FactoryGirl.create(:transit_agency,:id=>8)
    item = JSON::parse('
      {
        "pk": 1,
        "model": "tnt.transitrouter",
        "fields": {
          "agencies": [
            4,
            7,
            8
          ],
          "name": "Google Transit",
          "description": ""
        }
      }
      ')
    Util::DataImport::import_transit_router item
    fields = item['fields']
    new_record = TransitRouter.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    if fields['agencies']
      new_record.transit_agencies.collect{|c| c.id}.sort.should eq fields['agencies'].sort
    end

  end

  it "imports stories correctly" do
    item = JSON::parse('
      {
        "pk": 2,
        "model": "tnt.story",
        "fields": {
          "story": "<p>\r\n\t&nbsp;</p>\r\n<p class=\"p1\">\r\n\t<strong>The Night Refuge</strong></p>\r\n<p class=\"p1\">\r\n\t4am. &nbsp;Thick fog. &nbsp;Winding roads. &nbsp;Pitch black. &nbsp;Deer on our right, scared us half to death. &nbsp;Hooting owl on the left, we scared it half to death. &nbsp;Foxes running stupidly in front of our car. &nbsp;A coyote pack too smart to be seen except the glows of their eyes.</p>\r\n<p class=\"p1\">\r\n\tThat is how our journey to the Tule Elk Range in Point Reyes began. &nbsp;We left extremely early to ensure we saw something alive. &nbsp;Now, going in the middle of the night, the only predators to survive when humans are sleeping, were abound!</p>\r\n<p class=\"p1\">\r\n\tAfter hiking just 15 minutes, my friend whispers loudly to my brother and I in front &quot;Guys.. look up&quot;. &nbsp;I saw nothing. &nbsp;Through the fog, I just saw bushes, spiky bushes, spiky bushes that happened to be 10 elk right in the path of our trail!</p>\r\n<p class=\"p1\">\r\n\t<a href=\"http://imgur.com/FifWK,74zcj,tqJWL#2\">http://imgur.com/FifWK,74zcj,tqJWL#2</a></p>\r\n<p class=\"p1\">\r\n\tWe got closer, and before we knew it, we had separated a herd of 60 elk between the trail. &nbsp;Apparently we woke them before the early morning and thier young were still asleep and not able to join their mothers in the hustle. &nbsp;We respectfully backed up and let the mothers call for their young, and for the young to call to their mothers:</p>\r\n<p class=\"p1\">\r\n\t<a href=\"http://www.facebook.com/photo.php?v=10101229698072061\" target=\"_blank\">http://www.facebook.com/photo.php?v=10101229698072061</a></p>\r\n<p class=\"p1\">\r\n\tThe fog was so thick as we walked a long that we startled the elk as much as they startled us. &nbsp;We passed hundreds of elk. &nbsp;Them staring at us. &nbsp;Us staring at them. &nbsp;The deeper we went, the thinner the groups became. &nbsp;Before the elks traveled in herims of 40, now groups of 4 bachelors watched us upon every hill</p>\r\n<p class=\"p1\">\r\n\t<a href=\"http://imgur.com/FifWK,74zcj,tqJWL#1\">http://imgur.com/FifWK,74zcj,tqJWL#1</a></p>\r\n<p class=\"p1\">\r\n\tThese bulls with their razor sharp horns, seemed to be guarding something, on alert for any intruders. &nbsp;However they failed in stopping us, because we arrived unscathed into their protected lands.. the bull horn training grounds.</p>\r\n<p class=\"p1\">\r\n\t<a href=\"http://imgur.com/FifWK,74zcj,tqJWL#0\">http://imgur.com/FifWK,74zcj,tqJWL#0</a></p>\r\n<p class=\"p1\">\r\n\tOver 50 bachelor elks surrounded the watering hole, all &quot;fighting&quot; with each other. &nbsp;One elk would put their horns down, and immediately a battle ensued. &nbsp;Endlessly training for their shot of being the dominant bull next season. &nbsp;Respect.</p>\r\n<p class=\"p1\">\r\n\tAfter hiking 5 miles through the Tule Elk Range, we reached the end, the sun shone brightly, however the fog was still thick as ever. &nbsp;On our journey back, we saw no elk. &nbsp;Just humans, at least 50 of them, loud as ever.</p>\r\n",
          "travel_mode_from": "DRIVE",
          "author": 2301,
          "created_at": "2012-08-20",
          "object_id": 369,
          "happened_at": "2012-08-11",
          "travel_mode_to": "DRIVE",
          "content_type": 27
        }
      }')
    Util::DataImport::import_story item
    fields = item['fields']
    new_record = Story.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.to_travel_mode.should eq TravelMode.find_by_name(fields['travel_mode_to'].downcase.capitalize)
    new_record.from_travel_mode.should eq TravelMode.find_by_name(fields['travel_mode_from'].downcase.capitalize)
    new_record.user_id.should eq fields['author']
    new_record.happened_at.should eq fields['happened_at']
    new_record.story.should eq fields['story']
  end

  it "imports recent activity correctly" do
    item = JSON::parse('{
      "pk": 1,
      "model": "tnt.recentactivity",
      "fields": {
        "favorites_link1": "http://transitandtrails.org/trips/55/",
        "favorites_link3_text": "Sutro Secret (Weekend Sherpa)",
        "favorites_link3": "http://transitandtrails.org/trips/42/",
        "favorites_link2": "http://transitandtrails.org/trips/21/",
        "favorites_link5": "http://transitandtrails.org/trailheads/970/",
        "name": "Recent Activity",
        "favorites_type1": "trip-type",
        "recent_news_text": "Brand new video! <a href=\"http://www.youtube.com/watch?v=RuUB6Bo2StA&feature=player_embedded\" target=\"_blank\">\"What\'s Around You?\"</a>.\r\n\r\nA whole new way of exploring the natural world around you. The adventure starts when you walk out the door.\r\n",
        "favorites_type3": "trip-type",
        "favorites_type2": "trip-type",
        "favorites_type5": "trailhead-type",
        "favorites_type4": "trip-type",
        "favorites_link4": "http://transitandtrails.org/trips/17/",
        "highlighted": true,
        "favorites_link4_text": "Wildcat to Orinda (Transit to Ridge)",
        "favorites_link2_text": "Sausalito to Muir Woods (video)",
        "favorites_link1_text": "Overnight at Hawk",
        "favorites_link5_text": "Muir Woods Visitor Center",
        "description": "Not necessary"
      }
    }')
    Util::DataImport::import_recent_activity item
    fields = item['fields']
    new_record = RecentActivity.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.highlighted.should eq fields['highlighted']
    new_record.recent_news_text.should eq fields['recent_news_text']

    new_record.favorites_link1.should eq fields['favorites_link1']
    new_record.favorites_type1.should eq fields['favorites_type1']
    new_record.favorites_link1_text.should eq fields['favorites_link1_text']

    new_record.favorites_link2.should eq fields['favorites_link2']
    new_record.favorites_type2.should eq fields['favorites_type2']
    new_record.favorites_link2_text.should eq fields['favorites_link2_text']

    new_record.favorites_link3.should eq fields['favorites_link3']
    new_record.favorites_type3.should eq fields['favorites_type3']
    new_record.favorites_link3_text.should eq fields['favorites_link3_text']

    new_record.favorites_link4.should eq fields['favorites_link4']
    new_record.favorites_type4.should eq fields['favorites_type4']
    new_record.favorites_link4_text.should eq fields['favorites_link4_text']

    new_record.favorites_link5.should eq fields['favorites_link5']
    new_record.favorites_type5.should eq fields['favorites_type5']
    new_record.favorites_link5_text.should eq fields['favorites_link5_text']
  end

  it "imports featured tab correctly" do
    item = JSON::parse('
      {
        "pk": 1,
        "model": "tnt.featuredtab",
        "fields": {
          "link5": "",
          "text2": "Try something new!",
          "link4_text": "",
          "link1": "http://transitandtrails.org/challenge/",
          "name": "Featured Tab",
          "link3": "",
          "text3": "Get outside and get moving!",
          "image": "featured/featured-tab/417418_10150550121088404_264884664_n.jpg",
          "link2": "http://blog.transitandtrails.org/2012/07/what-parks-and-trails-are-around-you/",
          "link2_text": "On the blog",
          "highlighted": false,
          "header": "TAKE THE CHALLENGE!",
          "link4": "",
          "text1": "Go for a walk, hike, run or ride in a whole new way.",
          "image_link": "http://transitandtrails.org/challenge/",
          "link5_text": "",
          "link3_text": "",
          "link1_text": "Challenge",
          "description": "Not necessary"
        }
      }
      ')
    Util::DataImport::import_featured_tab item
    fields = item['fields']
    new_record = FeaturedTab.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.header.should eq fields['header']
    new_record.highlighted.should eq fields['highlighted']
    new_record.text1.should eq fields['text1']
    new_record.text2.should eq fields['text2']
    new_record.text3.should eq fields['text3']

    unless new_record.image.blank?
      new_record.image.should_not be_blank
    end

    new_record.image_link

    new_record.link1.should eq fields['link1']
    new_record.link1_text.should eq fields['link1_text']

    new_record.link2.should eq fields['link2']
    new_record.link2_text.should eq fields['link2_text']

    new_record.link3.should eq fields['link3']
    new_record.link3_text.should eq fields['link3_text']

    new_record.link4.should eq fields['link4']
    new_record.link4_text.should eq fields['link4_text']

    new_record.link5.should eq fields['link5']
    new_record.link5_text.should eq fields['link5_text']

  end

  it "imports agencies correctly" do
    item = JSON::parse('
      {
        "pk": 4,
        "model": "tnt.agency",
        "fields": {
          "logo": "baosc.png",
          "cpad_agency_layer": "Joint",
          "link": "http://www.parks.ca.gov/",
          "name": "California Department of Parks and Recreation",
          "description": null
        }
      }')
    Util::DataImport::import_agency item
    fields = item['fields']
    new_record = Agency.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.link.should eq fields['link']
    unless fields['logo'].blank?
      new_record.logo.should_not be_blank
    end

  end

  it "imports regional landing pages correctly" do
    item = JSON::parse('
      {
        "pk": 7,
        "model": "tnt.regionallandingpage",
        "fields": {
          "map_center": "POINT (-93.2649544231687031 44.9790773054617006)",
          "path": "TC",
          "name": "Minneapolis",
          "description": ""
        }
      }')
    Util::DataImport::import_regional_landing_page item
    fields = item['fields']
    new_record = RegionalLandingPage.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.path.should eq fields['path']
    new_record.longitude.should eq -93.2649544231687031
    new_record.latitude.should eq 44.9790773054617006
  end

  it "imports parks correctly" do
    item = JSON::parse(
      '{
        "pk": 13780,
        "model": "tnt.park",
        "fields": {
          "imported": true,
          "cpad_holding_id": null,
          "cpad_unit_id": 373,
          "description": null,
          "agency": 681,
          "acres": 6,
          "county": "San Luis Obispo",
          "county_slug": "san-luis-obispo",
          "link": null,
          "non_profit_partner": null,
          "geom": "MULTIPOLYGON (((-120.6778337542494057 35.2459292901028647, -120.6780587797285165 35.2455394597726865, -120.6781060805927126 35.2455575880658145, -120.6782062709410610 35.2455965322667240, -120.6784503063460505 35.2454531255531194, -120.6787287126712300 35.2452683901590547, -120.6789640835467168 35.2450282384723650, -120.6793177851364476 35.2446660246116892, -120.6793642855875390 35.2446171014201894, -120.6793464429058531 35.2445329616935012, -120.6796308414623269 35.2445329343717262, -120.6796025397616177 35.2445921705404501, -120.6793032711659777 35.2452338536991903, -120.6789077449800232 35.2453236541850927, -120.6782303478097162 35.2456608192093910, -120.6778731180333608 35.2462107823197854, -120.6780045043952185 35.2467872538395142, -120.6779312080270756 35.2468993140781848, -120.6778139841454163 35.2473087712361135, -120.6776706469406122 35.2472532876808486, -120.6776983571663919 35.2470486756741934, -120.6777443415295892 35.2466875483271522, -120.6777514154527609 35.2464400032953407, -120.6777570361281988 35.2462324767514374, -120.6776514457544778 35.2461541804962764, -120.6776768255789278 35.2461316617893701, -120.6777020696749929 35.2461051879824936, -120.6777245657579982 35.2460787671738771, -120.6777510915468952 35.2460494456821181, -120.6777735509465828 35.2460213465487300, -120.6777958943298330 35.2459904169229503, -120.6778141664326967 35.2459612824042381, -120.6778337542494057 35.2459292901028647)), ((-120.6719873109352790 35.2706286870222172, -120.6721585587450818 35.2698437120528681, -120.6725403578562776 35.2698845496693778, -120.6724678034735518 35.2701458295363111, -120.6723935728494865 35.2703924853165773, -120.6721979230370465 35.2710194550338514, -120.6716535110438571 35.2722810340306978, -120.6714543276050620 35.2727889903635017, -120.6714871058772758 35.2729463842230047, -120.6714802205418948 35.2729602122739578, -120.6714732494002504 35.2729740417222217, -120.6706077533082180 35.2725229061236973, -120.6706372029641585 35.2724355286917302, -120.6706558655912005 35.2723801546110352, -120.6706890008679522 35.2722818393025364, -120.6709964518066300 35.2718939780310379, -120.6710499761307176 35.2718266947706738, -120.6712920408255343 35.2715213801583829, -120.6713016051748895 35.2715092240767163, -120.6719825152759569 35.2706506640636306, -120.6719873109352790 35.2706286870222172)))",
          "slug": "san-luis-creek-open-space",
          "name": "San Luis Creek Open Space"
        }
      }')
    Util::DataImport::import_park item
    fields = item['fields']
    new_record = Park.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.agency_id.should eq fields['agency']
    new_record.acres.should eq fields['acres']
    new_record.county.should eq fields['county']
    new_record.county_slug.should eq fields['county_slug']
    new_record.slug.should eq fields['slug']
    new_record.link.should eq fields['link']
  end

  it "imports trips correctly" do
    FactoryGirl.create(:trip_feature,:id=>2)
    FactoryGirl.create(:trip_feature,:id=>3)
    FactoryGirl.create(:trip_feature,:id=>4)
    item = JSON::parse(
      '{
  "pk": 4,
  "model": "tnt.trip",
  "fields": {
    "flickr_set_url": "",
    "name": "Joe Rodota and West County Trails",
    "end_date": null,
    "author": 16,
    "route": "[[38.4370291503125,-122.72460427862802],[38.4370291503125,-122.72460427862802],[38.4370291503125,-122.72460427862802],[38.4370291503125,-122.72460427862802],[38.4370291503125,-122.72460427862802],[38.4370291503125,-122.72460427862802]]",
    "ending_point": 492,
    "people": [

    ],
    "intensity": 1,
    "geom": "LINESTRING (-122.7246042786280213 38.4370291503124974, -122.7246042786280213 38.4370291503124974, -122.7246042786280213 38.4370291503124974, -122.7246042786280213 38.4370291503124974, -122.7246042786280213 38.4370291503124974)",
    "features": [
      2,
      3,
      4    ],
    "activity": null,
    "duration": "Day Trip",
    "starting_point": 493,
    "start_date": null,
    "description": "<p>\r\n\tTwo connected level paved trails (biking, running, hiking) from Santa Rosa to Sebastopol to Forestville, with access to Laguna de Santa Rosa Wetlands Preserve for good birding.</p>\r\n"
  }
}
')
    Util::DataImport::import_trip item
    fields = item['fields']
    new_record = Trip.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    intensities = {1=>"Easy",2=>"Moderate",3=>"Strenuous"}
    new_record.intensity.should eq Intensity.find_by_name(intensities[fields['intensity']])
    new_record.duration.should eq Duration.find_by_name(fields['duration'])
    new_record.starting_trailhead_id.should eq fields['starting_point']
    new_record.ending_trailhead_id.should eq fields['ending_point']
    new_record.user_id.should eq fields['author']
    new_record.route.should eq fields['route']
    if fields['features']
      new_record.trip_features.collect{|c| c.id}.sort.should eq fields['features'].sort
    end
  end

  it "imports nonprofit partners correctly" do
    item = JSON::parse(
      '{
        "pk": 1,
        "model": "tnt.nonprofitpartner",
        "fields": {
          "logo": "baosc.png",
          "link": "http://www.parksconservancy.org/",
          "name": "Golden Gate National Parks Conservancy",
          "description": ""
        }
      }')
    Util::DataImport::import_non_profit_partner item
    fields = item['fields']
    new_record = NonProfitPartner.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.link.should eq fields['link']
    unless fields['logo'].blank?
      new_record.logo.should_not be_blank
    end

  end


  it "imports trailheads correctly" do
    FactoryGirl.create(:trailhead_feature,:id=>4)
    FactoryGirl.create(:trailhead_feature,:id=>5)
    FactoryGirl.create(:trailhead_feature,:id=>6)
    item = JSON::parse(
      '{
        "pk": 48,
        "model": "tnt.trailhead",
        "fields": {
          "name": "West Winton Avenue Park Entrance",
          "author": 1,
          "agency": null,
          "park": null,
          "longitude": -122.145099,
          "cpad_park_name": "",
          "rideshare": null,
          "features": [
            4,
            5,
            6
          ],
          "location": "POINT (-122.1450990000000019 37.6473949995000012)",
          "latitude": 37.6473949995,
          "zimride_url": null,
          "approved": null,
          "description": ""
        }
      }')
    Util::DataImport::import_trailhead item
    fields = item['fields']
    new_record = Trailhead.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rideshare.should eq fields['rideshare']
    new_record.latitude.should eq fields['latitude']
    new_record.longitude.should eq fields['longitude']
    new_record.approved.should eq fields['approved']
    new_record.user_id.should eq fields['author']
    new_record.park_id.should eq fields['park']
    if fields['features']
      new_record.trailhead_features.collect{|c| c.id}.sort.should eq fields['features'].sort
    end
  end

  it "imports campgrounds correctly" do
    FactoryGirl.create(:campground_feature,:id=>4)
    FactoryGirl.create(:campground_feature,:id=>5)
    FactoryGirl.create(:campground_feature,:id=>6)
    item = JSON::parse(
      '{
        "pk": 2,
        "model": "tnt.campground",
        "fields": {
          "name": "Del Valle Regional Park",
          "author": 1,
          "agency": 3,
          "park": 6,
          "longitude": -121.686678007,
          "features": [
            4,
            5,
            6
          ],
          "location": "POINT (-121.6866780069999976 37.5674622490000019)",
          "latitude": 37.567462249,
          "approved": true,
          "description": ""
        }
      }')
    Util::DataImport::import_campground item
    fields = item['fields']
    new_record = Campground.find(item['pk'])
    new_record.should_not be nil
    new_record.id.should eq item['pk']
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.latitude.should eq fields['latitude']
    new_record.longitude.should eq fields['longitude']
    new_record.approved.should eq fields['approved']
    new_record.user_id.should eq fields['author']
    new_record.park_id.should eq fields['park']
    if fields['features']
      new_record.campground_features.collect{|c| c.id}.sort.should eq fields['features'].sort
    end
  end

  it "imports campground maps correctly" do
    item = JSON::parse(
      '{
        "pk": 2,
        "model": "tnt.campground",
        "fields": {
          "name": "Del Valle Regional Park",
          "user": 1,
          "campground": 6,
          "description": "Test",
          "map": "baosc.png",
          "url": "http://transitandtrails.org"
        }
      }')
    Util::DataImport::import_campground_map item
    fields = item['fields']
    new_record = Map.last
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.url.should eq fields['url']
    new_record.user_id.should eq fields['user']
    unless fields['map'].blank?
      new_record.map.should_not be_blank
    end
  end

  it "imports campground photos correctly" do
    item = JSON::parse(
      '{
        "pk": 2,
        "model": "tnt.campgroundphoto",
        "fields": {
          "flickr_id": "34243255435",
          "user": 1,
          "campground": 6,
          "description": "Test",
          "map": "baosc.png",
          "url": "http://transitandtrails.org"
        }
      }')
    Util::DataImport::import_campground_photo item
    fields = item['fields']
    new_record = Photo.last
    new_record.should_not be nil
    new_record.flickr_id.should eq fields['flickr_id']
    new_record.uploaded_to_flickr.should eq fields['uploaded_to_flickr']
    new_record.user_id.should eq fields['user']
    # unless fields['image'].blank?
    #   new_record.image.should_not be_blank
    # end
  end


  it "imports trip maps correctly" do
    item = JSON::parse(
      '{
        "pk": 2,
        "model": "tnt.tripmap",
        "fields": {
          "name": "Del Valle Regional Park",
          "user": 1,
          "campground": 6,
          "description": "Test",
          "map": "baosc.png",
          "url": "http://transitandtrails.org"
        }
      }')
    Util::DataImport::import_trip_map item
    fields = item['fields']
    new_record = Map.last
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.url.should eq fields['url']
    new_record.user_id.should eq fields['user']
    unless fields['map'].blank?
      new_record.map.should_not be_blank
    end
  end


  it "imports campground features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "marker_icon": "baosc.png"}}')
    Util::DataImport::import_campground_feature item
    fields = item['fields']
    new_record = CampgroundFeature.find_by_name(fields['name'])
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rank.should eq fields['rank']
    new_record.link_url.should eq fields['link_url']
    new_record.category_id.should eq fields['category']
    unless fields['marker_icon'].blank?
      new_record.marker_icon.should_not be_blank
    end
  end

  it "imports trailhead features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "marker_icon": "baosc.png"}}')
    Util::DataImport::import_trailhead_feature item
    fields = item['fields']
    new_record = TrailheadFeature.find_by_name(fields['name'])
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rank.should eq fields['rank']
    new_record.link_url.should eq fields['link_url']
    new_record.category_id.should eq fields['category']
    unless fields['marker_icon'].blank?
      new_record.marker_icon.should_not be_blank
    end
  end

  it "imports trip features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "marker_icon": "baosc.png"}}')
    Util::DataImport::import_trip_feature item
    fields = item['fields']
    new_record = TripFeature.find_by_name(fields['name'])
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rank.should eq fields['rank']
    new_record.link_url.should eq fields['link_url']
    new_record.category_id.should eq fields['category']
    unless fields['marker_icon'].blank?
      new_record.marker_icon.should_not be_blank
    end
  end


  it "imports users properly" do
    item = JSON::parse('{"pk":18,"model":"auth.user","fields":{"username":"jereme","first_name":"Jereme","last_name":"Monteau","is_active":true,"is_superuser":false,"is_staff":false,"last_login":"2012-08-03 16:39:36","groups":[1],"user_permissions":[],"password":"sha1$a3f08$d62f324e83384347d6cb1499c152f81b6cb6cc9f","email":"me@jmoe.com","date_joined":"2009-03-24 09:03:01"}}')
    Util::DataImport::import_user item
    new_user = User.find_by_username('jereme')
    new_user.should_not be nil
    new_user.id.should eq item['pk']
    new_user.username.should eq item['fields']['username']
    new_user.email.should eq item['fields']['email']
    new_user.django_password.should eq item['fields']['password']
    new_user.admin.should eq item['fields']['is_superuser'] || item['fields']['is_staff']
    new_user.last_sign_in_at.should eq item['fields']['last_login']
    new_user.created_at.should eq item['fields']['date_joined']
    new_user.should be_confirmed
  end

  it "does not import inactive users" do
    item = JSON::parse('{"pk":18,"model":"auth.user","fields":{"username":"jereme","first_name":"Jereme","last_name":"Monteau","is_active":false,"is_superuser":false,"is_staff":false,"last_login":"2012-08-03 16:39:36","groups":[1],"user_permissions":[],"password":"sha1$a3f08$d62f324e83384347d6cb1499c152f81b6cb6cc9f","email":"me@jmoe.com","date_joined":"2009-03-24 09:03:01"}}')
    imported = Util::DataImport::import_user item
    imported.should be false
  end

  it "imports user profiles properly" do
    user = JSON::parse('{"pk":18,"model":"auth.user","fields":{"username":"jereme","first_name":"Jereme","last_name":"Monteau","is_active":true,"is_superuser":false,"is_staff":false,"last_login":"2012-08-03 16:39:36","groups":[1],"user_permissions":[],"password":"sha1$a3f08$d62f324e83384347d6cb1499c152f81b6cb6cc9f","email":"me@jmoe.com","date_joined":"2009-03-24 09:03:01"}}')
    Util::DataImport::import_user user

    item = JSON::parse('{"pk":1,"model":"tnt.userprofile","fields":{"last_name":"Monteau","facebook_photo_url":null,"organization_avatar_thumbnail_url":"organizations_avatars/jereme/604e28c6-dcc0-11e1-8cda-1231380b3501.jpg","organization_avatar":"organizations_avatars/transit-trails/avatar_2.jpg","city":"Berkeley","first_name":"Jereme","zip":"94708","organization_name":"Transit & Trails","state":"CA","facebook_profile":null,"address1":"2794 Shasta Road","api_key":"e73f44a17ae5b1b9d6d129e818023ed8b0c6acd9b238c1bb88cba13c86065bfb","api_secret":"5cf75dfc79804e008d135df93da15317a67368d29cae84f1b93ba7a33d28d287","address2":"","website_address":"http://jmoe.com","beta":false,"facebook_profile_url":null,"user":18,"signup_source":"","avatar_thumbnail_url":"user_profiles_avatars/jereme/604e004e-dcc0-11e1-8cda-1231380b3501.jpg","avatar":"user_profiles_avatars/jereme/avatar.png","facebook":false}}')
    Util::DataImport::import_user_profile item
    new_profile = UserProfile.find(item['pk'])
    new_profile.user_id.should eq item['fields']['user']
    unless item['fields']['first_name'].blank?
      new_profile.firstname.should eq item['fields']['first_name']
    end
    unless item['fields']['last_name'].blank?
      new_profile.lastname.should eq item['fields']['last_name']
    end
    new_profile.address1.should eq item['fields']['address1']
    new_profile.address2.should eq item['fields']['address2']
    new_profile.city.should eq item['fields']['city']
    new_profile.state.should eq item['fields']['state']
    new_profile.zip.should eq item['fields']['zip']
    new_profile.zip.should eq item['fields']['zip']
    new_profile.api_key.should eq item['fields']['api_key']
    new_profile.api_secret.should eq item['fields']['api_secret']
    new_profile.organization_name.should eq item['fields']['organization_name']
    new_profile.signup_source.should eq item['fields']['signup_source']
    new_profile.website_address.should eq item['fields']['website_address']
    unless item['fields']['avatar'].blank?
      new_profile.avatar.should_not be_blank
      new_profile.avatar_url(:thumbnail).should_not be_blank
    end
    unless item['fields']['organization_avatar'].blank?
      new_profile.organization_avatar.should_not be_blank
      new_profile.organization_avatar_url(:thumbnail).should_not be_blank
    end
  end


  it "does not import user profiles if the user does not exist" do
    item = JSON::parse('{"pk":1,"model":"tnt.userprofile","fields":{"last_name":"Monteau","facebook_photo_url":null,"organization_avatar_thumbnail_url":"organizations_avatars/jereme/604e28c6-dcc0-11e1-8cda-1231380b3501.jpg","organization_avatar":"organizations_avatars/transit-trails/avatar_2.jpg","city":"Berkeley","first_name":"Jereme","zip":"94708","organization_name":"Transit & Trails","state":"CA","facebook_profile":null,"address1":"2794 Shasta Road","api_key":"e73f44a17ae5b1b9d6d129e818023ed8b0c6acd9b238c1bb88cba13c86065bfb","api_secret":"5cf75dfc79804e008d135df93da15317a67368d29cae84f1b93ba7a33d28d287","address2":"","website_address":"http://jmoe.com","beta":false,"facebook_profile_url":null,"user":18,"signup_source":"","avatar_thumbnail_url":"user_profiles_avatars/jereme/604e004e-dcc0-11e1-8cda-1231380b3501.jpg","avatar":"user_profiles_avatars/jereme/avatar.png","facebook":false}}')
    imported = Util::DataImport::import_user_profile item
    imported.should be false
  end
end
