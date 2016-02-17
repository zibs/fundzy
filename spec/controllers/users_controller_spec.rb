require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "#new" do
    before do
      get :new
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "instantiates a new User Object and sets it to @user instance" do
      expect(assigns(:user)).to be_a_new(User)
    end

  end

  describe "#create" do
    context "with valid attributes" do

      def valid_post_request
          post :create, user: FactoryGirl.attributes_for(:user)
      end

      it "creates a user record in the database" do
        expect {valid_post_request}.to change{ User.count }.by(1)
      end

      it "redirects to the homepage" do
        expect(valid_post_request).to redirect_to(root_path)
      end

      it "sets a flash message" do
          valid_post_request
          expect(flash[:success]).to be
      end

      it "signs the user in (session id's)" do
        valid_post_request
        expect(session[:user_id]).to eq(User.last.id)
      end

    end

    context "invalid attributes" do

      def invalid_post_request
        # can over ride the attributes for of FactoryGirl
          post :create, user: FactoryGirl.attributes_for(:user, {email: nil})
      end

      it "doesn't create a user record in the database" do
        expect{invalid_post_request}.to_not change{User.count}
      end
      it "renders the new template" do
        invalid_post_request
        expect(response).to render_template(:new)
      end
      it "sets a flash message" do
        invalid_post_request
        expect(flash[:warning]).to be
      end
    end

  end

end
