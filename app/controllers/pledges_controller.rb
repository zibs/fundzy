class PledgesController < ApplicationController
  before_action :authenticate_user, except: [:show, :index]

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @pledge = Pledge.new(pledge_params)

    @pledge.campaign = @campaign
    @pledge.user = current_user

    if @pledge.save
      redirect_to campaign_path(@campaign), flash: { success: "Pledged!"}
    else
    render "campaigns/show"
    end
  end


    private

      def pledge_params
        params.require(:pledge).permit(:amount)
      end
end
