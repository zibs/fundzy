class PublishingsController < ApplicationController
  before_action :authenticate_user


  def create
    campaign = current_user.campaigns.friendly.find(params[:campaign_id])
    if campaign.publish!
      redirect_to campaign, flash: { success: "Published!" }
    else
      redirect_to campaign, flash: { danger: "Already published!"}
    end

  end



end
