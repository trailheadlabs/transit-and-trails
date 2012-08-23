require 'spec_helper'
require 'util/data_import'

describe "DataImport" do

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

  it "imports features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "marker_icon": "baosc.png"}}')
    Util::DataImport::import_feature item
    fields = item['fields']
    new_record = Feature.find_by_name(fields['name'])
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
