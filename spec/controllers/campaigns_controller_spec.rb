require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do
  let(:user) {FactoryGirl.create(:user)}
  let(:campaign) {FactoryGirl.create(:campaign)}
  let(:other_campaign) {FactoryGirl.create(:campaign)}

  # let does the exact same -- shortcut cnoditional assignment
  # def campaign
  #   @campaign ||= FactoryGirl.create(:campaign)
  # end

  # convention to describe action
  describe "#new" do
    before{ log_in(user) }
    it "renders the new template" do
      # this mimics sending a get request to the new action
      get :new
      # respsonse is an object that is given to us by rspec that will help test things like redirects, render
      # render_template is an RSPEC matcher that helps us check if the controller renders the template with the given name.
      expect(response).to render_template(:new)
    end

    it "instantiates a new Campaign object and set it to @campaign" do
      get :new
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "#create" do
    before{ log_in(user) }

    context "with valid attributes" do

      def valid_request
        post :create, campaign: { name: "abc", description: "efg", goal: 150 }
      end

      it "creates a record in the database" do
        campaign_count_before = Campaign.count
        valid_request
        campaign_count_after = Campaign.count
        expect(campaign_count_after - campaign_count_before).to eq(1)
      end

      it "redirects to the campaign #show page" do
        valid_request
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end

      it "sets a flash notice message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do

      def invalid_request
        post :create, campaign: { name: "", description: "", goal: 4 }
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "doesn't a record in the database" do
        db_count_before = Campaign.count
        invalid_request
        db_count_after = Campaign.count
        expect(db_count_after).to eq(db_count_before)
      end

      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end

    end
  end

  describe "#show" do
    # before doing anything with this action, do this
    before do
      # GIVEN: a campaign
      @campaign = Campaign.create({name: "valid nadmeo", description: "valid_description",
                                    goal: 1000})
      # WHEN
      get :show, id: @campaign.id
    end

    it "finds the object by its id and sets it to a @campaign variable" do
      # THEN
      expect(assigns(:campaign)).to eq(@campaign)
    end

    it "renders the show template" do
      # THEN
      expect(response).to render_template(:show)
    end

    it "raises an error if the id passed doesn't match a record in the DB" do
      # use expect to raise error and pass it a block
        expect {get :show, id: 23123123915}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "fetches all the records and assigns them to @campaigns" do
      # GIVEN two campaigns
      c = FactoryGirl.create(:campaign)
      c1 = FactoryGirl.create(:campaign)
      # WHEN: we GET :index
      get :index
      # THEN
      expect(assigns(:campaigns)).to eq([c, c1])
      # good for test to be as agnostic as possible
    end
  end

  describe "#edit" do
    before{ log_in(user) }

    before do
      # given a campaign object
      # @c = FactoryGirl.create(:campaign)
      # WHEN we GET :edit
      get :edit, id: campaign
    end
      it "finds the campaign by id and sets it @campaign" do
        expect(assigns(:campaign)).to eq(campaign)
      end

      it  "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "#update" do
      before{ log_in(user) }
      context "with valid attributes" do
        before do
          patch :update, id: campaign.id, campaign: { name: "pew pew pew" }
        end
        it "updates the record with new parameter(s)" do
          # we must use campaign.reload in this scenario because the controller will instantiate another campaign object based on the idea, but it will live in another memory location. Which means `campaign` here will still have the old data, not the updated one. Reload will make ActiveRecord rerun the query and fetches the information from the DB again..
          expect(campaign.reload.name).to eq("pew pew pew")
        end

        it "redirects to :show" do
          expect(response).to redirect_to(campaign_path(campaign))
        end

        it "sets a flash notice message" do
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, id: campaign.id, campaign: { name: "" }
        end

        it "doesn't update the record" do
          expect(campaign.reload.name).to eq(campaign.name)
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end
        it "sets a flash alert message" do
            expect(flash[:alert]).to be
        end
      end
    end

    describe "#destroy" do

      context "authenticated user" do
        before {log_in(user)}

        context "authorized user" do

          let!(:campaign) {FactoryGirl.create(:campaign, {user: user})}

          def delete_request
            delete :destroy, id: campaign
          end

          it "destroys the campaign record in the database" do
            expect{delete_request}.to change{Campaign.count}.by(-1)
          end

          it "redirects to the home page" do
            delete_request
            expect(response).to redirect_to(root_path)
          end
        end

        context "unauthorized user" do
          it "raises an error" do
            expect{delete :destroy, id: other_campaign}.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

      end

      # let!(:campaign) {FactoryGirl.create(:campaign)}



      context "unauthenticated user" do

        it "redirects the user to the sign in page" do
          delete :destroy, id: campaign
          expect(response).to redirect_to(new_session_path)
        end

      end
    end
  end

    #   let!(:campaign) { FactoryGirl.create(:campaign) }
    #   # before do
    #   #   campaign # this will create the campaign
    #   #   @db_count = Campaign.count
    #   #   delete :destroy, id: campaign.id
    #   # end
    #   it "removes the campaign from the database" do
    #     # expect(Campaign.count).to be(0)
    #     # or
    #     # campaign
    #     expect {delete :destroy, id: campaign.id}.to change {Campaign.count}.by(-1)
    #   end
    #
    #   it "redirects to the campaign index page" do
    #     delete :destroy, id: campaign.id
    #     expect(response).to redirect_to(campaigns_path)
    #   end
    #
    #   it "sets a flash message" do
    #     delete :destroy, id: campaign.id
    #     expect(flash[:alert]).to be
    #   end
    # end
