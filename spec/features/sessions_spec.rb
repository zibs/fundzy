require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let!(:user){FactoryGirl.create(:user)}

  context "with valid credentials" do
    it "redirects to the homepage / shows user full name / displays `Signed In`" do
      visit new_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign In"

      expect(current_path).to eq(root_path)
      expect(page).to have_text /#{user.full_name}/i
      expect(page).to have_text /signed in/i

    end
  end
  context "with invalid credentials" do
    it "doesn't show the user's name, and displays failure message" do
      visit new_session_path
      fill_in "Email", with: "Look Upon My Works Ye Mighty and Despair@yeah.com"
      click_button "Sign In"

      expect(current_path).to eq(sessions_path)
      expect(page).to_not have_text /#{user.full_name}/i
      expect(page).to have_text /invalid credentials/i

    end
  end
  # end rspec
end
