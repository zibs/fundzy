require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  # let(:user) { create(:user) }
  # helper methods
  describe "#new" do
    it "renders the sign in page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "with valid credentials" do

      def sign_in_valid_user
        post :create, session: { email: user.email, password: user.password }
      end

      it "sets the session user_id to the user with the passed email" do
        # post :create, user: @user.email
        # post :create, user
        # binding.pry
        sign_in_valid_user
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the root path" do
        sign_in_valid_user
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash message" do
        sign_in_valid_user
        expect(flash[:success]).to be
      end
    end

    context "with invalid credentials" do

      def sign_in_invalid_user
        post :create, session: { email: user.email, password: user.first_name }
      end

      it "renders to the new template" do
        sign_in_invalid_user
        expect(response).to render_template(:new)
      end

      it "doesn't set the session id with invalid data " do
        sign_in_invalid_user
        expect(session[:user_id]).to eq(nil)

      end

      it "sets a flash message" do
        sign_in_invalid_user
        expect(flash[:warning]).to be
      end
    end
  end

  describe "#destroy" do

    before do
      # post :create, session: { email: user.email, password: user.password }
      request.session[:user_id] = user.id
      delete :destroy
    end

    it "sets the session id to nil" do
      # expect(session[:user_id]).to eq(nil)
      expect(session[:user_id]).to_not be
    end

    it "sets a flash message" do
      expect(flash[:danger]).to be
    end
    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end
  end



end
