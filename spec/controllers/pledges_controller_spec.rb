require 'rails_helper'

RSpec.describe PledgesController, type: :controller do
  # FactoryGirl.create(:pledge, campaign: campaign)???
  let(:campaign){create(:campaign)}
  let(:user){create(:user)}

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

end
