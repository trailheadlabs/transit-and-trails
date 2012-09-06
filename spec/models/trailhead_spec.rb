require 'spec_helper'

describe Trailhead do
  it "returns a park by bounds" do
    park = FactoryGirl.create(:park)
    trailhead = FactoryGirl.create(:trailhead)
    trailhead.park_by_bounds.id.should eq park.id
  end

  it "auto approves" do
    admin = FactoryGirl.create(:admin)
    trailhead = FactoryGirl.create(:trailhead, :user => admin)
    trailhead.should be_approved
  end

  it "returns categorized attributes" do
    category_1 = FactoryGirl.create(:category,:name=>"CategoryOne")
    category_2 = FactoryGirl.create(:category,:name=>"CategoryTwo")
    feature_1 = FactoryGirl.create(:trailhead_feature,:name=>"FeatureOne",:category=>category_1)
    feature_2 = FactoryGirl.create(:trailhead_feature,:name=>"FeatureTwo",:category=>category_1)
    feature_3 = FactoryGirl.create(:trailhead_feature,:name=>"FeatureThree",:category=>category_2)
    feature_4 = FactoryGirl.create(:trailhead_feature,:name=>"FeatureFour",:category=>category_2)
    trailhead = FactoryGirl.create(:trailhead)
    trailhead.trailhead_features << [feature_1,feature_2,feature_3]
    good_result = {'CategoryOne'=>[feature_1,feature_2],'CategoryTwo'=>[feature_3]}
    trailhead.categorized_attributes.should eq good_result
  end
end
