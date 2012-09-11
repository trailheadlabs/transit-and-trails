require 'spec_helper'

describe PhotosController do

  def valid_attributes
    {:photoable_id=>@trailhead.id,:photoable_type=>'Trailhead'}
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
        it "creates a new Photo" do
          expect {
            post :create, {:trailhead_id=>@trailhead.id,:photo => valid_attributes}, valid_session
          }.to change(Photo, :count).by(1)
        end

        it "assigns a newly created photo as @photo" do
          post :create, {:trailhead_id=>@trailhead.id,:photo => valid_attributes}, valid_session
          assigns(:photo).should be_a(Photo)
          assigns(:photo).should be_persisted
        end

        it "redirects to the created photo" do
          post :create, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:photo => valid_attributes}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end

      describe "with invalid params" do
        before(:each) do
          request.env["HTTP_REFERER"] = trailhead_url(@trailhead)
        end

        it "assigns a newly created but unsaved photo as @photo" do
          # Trigger the behavior that occurs when invalid params are submitted
          Photo.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:photo => {}}, valid_session
          assigns(:photo).should be_a_new(Photo)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Photo.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:photo => {}}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested photo" do
        photo = Photo.create! valid_attributes
        expect {
          delete :destroy, {:trailhead_id=>@trailhead.id,:id => photo.to_param}, valid_session
        }.to change(Photo, :count).by(-1)
      end

      it "redirects to the photos list" do
        photo = Photo.create! valid_attributes
        delete :destroy, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:id => photo.to_param}, valid_session
        response.should redirect_to(trailhead_url(@trailhead))
      end
    end

  end
end
