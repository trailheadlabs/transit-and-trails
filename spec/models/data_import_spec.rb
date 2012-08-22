require 'spec_helper'
require 'util/data_import'

describe "DataImport" do
  it "downloads the latest users" do
    json = Util::DataImport::latest_user_objects
    json.count.should be > 0
  end

  it "downloads the latest user profiles" do
    json = Util::DataImport::latest_user_profile_objects
    json.count.should be > 0
  end

  it "downloads the latest attribute categories" do
    json = Util::DataImport::latest_attribute_category_objects
    json.count.should be > 0
  end

  it "downloads the latest trip features" do
    json = Util::DataImport::latest_trip_feature_objects
    json.count.should be > 0
  end

  it "downloads the latest trailhead features" do
    json = Util::DataImport::latest_trailhead_feature_objects
    json.count.should be > 0
  end

  it "downloads the latest campground features" do
    json = Util::DataImport::latest_campground_feature_objects
    json.count.should be > 0
  end

  it "imports attribute categories correctly" do
    item = JSON::parse('{"pk": 8, "model": "tnt.attributecategory", "fields": {"visible": true, "name": "Trip Route", "rank": 1, "description": "What is the trip route - loop, out and back, one-way?"}}')
    Util::DataImport::import_attribute_category item
    fields = item['fields']
    new_record = Category.find(item['pk'])
    new_record.id.should eq item['pk']
    new_record.should_not be nil
    new_record.name.should eq fields['name']
    new_record.description.should eq fields['description']
    new_record.rank.should eq fields['rank']
    new_record.visible.should eq fields['visible']
  end

  it "imports features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "icon": ""}}')
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
      new_record.marker_con.should_not be_blank
    end
  end

it "imports campground features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "icon": ""}}')
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
      new_record.marker_con.should_not be_blank
    end
  end

it "imports trailhead features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "icon": ""}}')
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
      new_record.marker_con.should_not be_blank
    end
  end

it "imports trip features correctly" do
    item = JSON::parse('{"pk": 38, "model": "tnt.tripfeature", "fields": {"category": 3, "name": "Walking", "description": "Walking is the preferred means of transportation here. Check the trips info to find some cool trails and other places to check out. ", "rank": 1, "quantity": 0, "link_url": "http://nps.gov", "icon": ""}}')
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
      new_record.marker_con.should_not be_blank
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
