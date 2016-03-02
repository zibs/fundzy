require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  describe "Campaigns listing" do
    it "displays a text 'Recent Campaigns'" do
      # this simulates users typing the capaign_path in the address bar to actually visit the page
      visit campaigns_path
      # we ahve access to an object `page` that containst he rendered HTML page and we can use it with RPSEC matches to perform tests.
      expect(page).to have_text "Recent Campaigns"
    end

    it "displays an h2 header with `All Campaigns`" do
      visit campaigns_path
      expect(page).to have_selector "h2", text: "All Campaigns"
    end

    it "has a page title of `Fund.zy`" do
      visit campaigns_path
      expect(page).to have_title "Fund.zy"
    end

    it "displays a campaign's name" do
      campaign = FactoryGirl.create(:campaign)
      visit campaigns_path
      # this will open a web page with the current state.
      # save_and_open_page
      expect(page).to have_text /#{campaign.name}/i
    end

  end
end
