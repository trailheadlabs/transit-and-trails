require 'spec_helper'

describe MapsController do

  def valid_attributes
    {:mapable_id=>@trailhead.id,:mapable_type=>'Trailhead'}
  end

  def valid_session
    {}
  end

  context "logged in" do
    before(:each) do
      @user = FactoryGirl.create(:admin)
      sign_in :user, @user
      controller.user_signed_in?.should be_true
      @trailhead = FactoryGirl.create(:trailhead)
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new map" do
          expect {
            post :create, {:trailhead_id=>@trailhead.id,:map => valid_attributes}, valid_session
          }.to change(Map, :count).by(1)
        end

        it "assigns a newly created map as @map" do
          post :create, {:trailhead_id=>@trailhead.id,:map => valid_attributes}, valid_session
          assigns(:map).should be_a(Map)
          assigns(:map).should be_persisted
        end

        it "redirects to the created map" do
          post :create, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:map => valid_attributes}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end

      describe "with invalid params" do
        before(:each) do
          request.env["HTTP_REFERER"] = trailhead_url(@trailhead)
        end

        it "assigns a newly created but unsaved map as @map" do
          # Trigger the behavior that occurs when invalid params are submitted
          Map.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:map => {}}, valid_session
          assigns(:map).should be_a_new(Map)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Map.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:map => {}}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested map" do
        map = Map.create! valid_attributes
        expect {
          delete :destroy, {:trailhead_id=>@trailhead.id,:id => map.to_param}, valid_session
        }.to change(Map, :count).by(-1)
      end

      it "redirects to the maps list" do
        map = Map.create! valid_attributes
        delete :destroy, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:id => map.to_param}, valid_session
        response.should redirect_to(trailhead_url(@trailhead))
      end
    end

  end
end
