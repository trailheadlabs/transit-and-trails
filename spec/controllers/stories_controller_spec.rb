require 'spec_helper'

describe StoriesController do

  def valid_attributes
    {:storytellable_id=>@trailhead.id,:storytellable_type=>'Trailhead'}
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
        it "creates a new story" do
          expect {
            post :create, {:trailhead_id=>@trailhead.id,:story => valid_attributes}, valid_session
          }.to change(Story, :count).by(1)
        end

        it "assigns a newly created story as @story" do
          post :create, {:trailhead_id=>@trailhead.id,:story => valid_attributes}, valid_session
          assigns(:story).should be_a(Story)
          assigns(:story).should be_persisted
        end

        it "redirects to the created story" do
          post :create, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:story => valid_attributes}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end

      describe "with invalid params" do
        before(:each) do
          request.env["HTTP_REFERER"] = trailhead_url(@trailhead)
        end

        it "assigns a newly created but unsaved story as @story" do
          # Trigger the behavior that occurs when invalid params are submitted
          Story.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:story => {}}, valid_session
          assigns(:story).should be_a_new(Story)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Story.any_instance.stub(:save).and_return(false)
          post :create, {:trailhead_id=>@trailhead.id,:story => {}}, valid_session
          response.should redirect_to(trailhead_url(@trailhead))
        end
      end
    end

    # describe "DELETE destroy" do
    #   it "destroys the requested story" do
    #     story = Story.create! valid_attributes
    #     expect {
    #       delete :destroy, {:trailhead_id=>@trailhead.id,:id => story.to_param}, valid_session
    #     }.to change(Story, :count).by(-1)
    #   end

    #   it "redirects to the storys list" do
    #     story = Story.create! valid_attributes
    #     delete :destroy, {:trailhead_id=>@trailhead.id,:trailhead_id=>@trailhead.id,:id => story.to_param}, valid_session
    #     response.should redirect_to(trailhead_url(@trailhead))
    #   end
    # end

  end
end
