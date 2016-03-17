class NearbyCampaignsController < ApplicationController
  before_action :authenticate_user

  def index
    @campaigns = Campaign.near([current_user.latitude, current_user.longitude], 50, units: :km)
  end

end
