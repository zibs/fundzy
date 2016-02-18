class CampaignsController < ApplicationController
  before_action :find_campaign, only: [:show, :edit, :update]
  before_action :authenticate_user, except: [:show, :index]

  def index
    @campaigns = Campaign.order("created_at ASC")
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      flash[:notice] = "Campaign Created"
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = "Campaign not created"
      render :new
    end
    # this sends successful empty http response (200)
    # render nothing: true
  end

  def show
    # find_by_id won't raise error if record is not found
  end

  def edit

  end

  def update
    if @campaign.update(campaign_params)
      redirect_to(campaign_path(@campaign), { notice: "Campaign updated!"})
    else
      flash[:alert] = "Campaign not updated"
      render :edit
    end
  end

  def destroy
    campaign = current_user.campaigns.find(params[:id])
    campaign.destroy
    redirect_to((root_path), flash: {danger: "task removed!"})
  end

      private

        def campaign_params
          params.require(:campaign).permit([:name, :goal, :description, :end_date])
        end

        def find_campaign
          @campaign = Campaign.find(params[:id])
        end

end
