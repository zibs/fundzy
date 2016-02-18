require 'rails_helper'

RSpec.describe PledgesController, type: :controller do
  # FactoryGirl.create(:pledge, campaign: campaign)???
  let(:campaign){create(:campaign)}
  let(:user){create(:user)}
  let(:pledge){create(:pledge, {campaign: campaign, user: user})}
  # This will create a new user, new campaign and pledge, which will be different than the `user`.
  let(:other_pledge){create(:pledge)}

  describe "#create" do

    context "with unsigned in user" do
      it "redirects to the sign in page" do
        post :create, campaign_id: campaign.id, pledge: attributes_for(:pledge)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with signed in user" do
      # probably going to have to do this alot, so let's refactor it...
      # before do
      #   request.session[:user_id] = user.id
      # end
      before { log_in(user) }

      context "with valid parameters" do
        def send_valid_request
          post :create, campaign_id: campaign.id, pledge: attributes_for(:pledge)
        end

        it "create the record in the database associated with the campaign" do
          expect{send_valid_request}.to change{campaign.pledges.count}.by(1)
        end

        it "associates the pledge with the logged in user" do
          send_valid_request
          expect(Pledge.last.user).to eq(user)
        end

        it "redirects to the campaign show page" do
          expect(send_valid_request).to redirect_to(campaign_path(campaign))
        end

        it "sets a flash notice" do
          send_valid_request
          expect(flash[:success]).to be
        end
      end

      context "with invalid parameters" do

      end

    end


  end

  describe "#destroy" do

    context "with unauthenticated user" do
      let!(:pledge){create(:pledge)}
      it "redirects to sign in page" do
        delete :destroy, id: pledge.id, campaign_id: campaign.id
        expect(response).to redirect_to new_session_path
      end
    end

    context "with authenticated user" do
      before { log_in(user) }

      context "authorized user" do
        let!(:pledge){create(:pledge, {campaign: campaign, user: user})}

        def destroy_pledge
          delete :destroy, id: pledge, campaign_id: campaign
        end

        it "removes the pledge from the database" do
          expect{destroy_pledge}.to change{Pledge.count}.by(-1)
        end

        it "redirects to the campaign show page" do
          destroy_pledge
          expect(response).to redirect_to(campaign_path(campaign))
        end

        it "sets a flash message" do
          destroy_pledge
          expect(flash[:danger]).to be
        end
      end

      context "unauthorized user" do
        it "raises an error" do
          expect do
            delete :destroy, id: other_pledge.id, campaign_id: other_pledge.campaign_id
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    end

  end
end
