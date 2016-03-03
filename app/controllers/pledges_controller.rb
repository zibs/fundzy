class PledgesController < ApplicationController
  before_action :find_pledge, only: [:edit, :show, :update]
  before_action :authenticate_user, except: [:show, :index]
  # before_action :authorize_user, only: [:create, :destroy]

  def create
    @campaign = Campaign.friendly.find(params[:campaign_id])
    @pledge = Pledge.new(pledge_params)

    @pledge.campaign = @campaign
    @pledge.user = current_user

    if @pledge.save
      redirect_to campaign_path(@campaign), flash: { success: "Pledged!"}
    else
    render "campaigns/show"
    end
  end

  def destroy
    pledge = current_user.pledges.find(params[:id])
    pledge.destroy
    # campaign = Campaign.find(params[:campaign_id])
    redirect_to campaign_path(params[:campaign_id]), flash: {danger: "Pledge Unpledged!"}
  end


    private

      def pledge_params
        params.require(:pledge).permit(:amount)
      end

      # def find_pledge
        # @pledge = Pledge.find(params[:id])
      # end
      #
      # def authorized_user
      #
      # end
end
