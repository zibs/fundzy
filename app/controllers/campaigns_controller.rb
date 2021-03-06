class CampaignsController < ApplicationController
  before_action :find_campaign, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:show, :index]
  # before_action :authorize_user
  REWARD_COUNT = 3

  def index
    # @campaigns = Campaign.order("created_at ASC")
    @campaigns = Campaign.order("created_at ASC").published
  end

  def new
    @campaign = Campaign.new
    build_associated_rewards
  end

  def create
    service = Campaigns::CreateCampaign.new(params: campaign_params, user: current_user)
    # @campaign = Campaign.new(campaign_params)
    # @campaign.user = current_user
    if service.call
      flash[:success] = "Campaign Created"
      redirect_to campaign_path(service.campaign)
    else
      @campaign.service.campaign
      build_associated_rewards
      flash[:danger] = "Campaign not created"
      render :new
    end
    # this sends successful empty http response (200)
    # render nothing: true
  end

  def show
    @pledge = Pledge.new
    @comment = Comment.new
    # find_by_id won't raise error if record is not found
  end

  def edit
    build_associated_rewards
  end

  def update
    # we need to force the slug to be nil before updating it in order to have FriendlyId generate a new slug for su. We're using `history` option with FriendlyId so old URLs still work.
    @campaign.slug = nil
    if @campaign.update(campaign_params)
      redirect_to(campaign_path(@campaign), { notice: "Campaign updated!"})
    else
      flash[:alert] = "Campaign not updated"
      render :edit
    end
  end

  def destroy
    user_campaign.destroy
    # campaign = current_user.campaigns.friendly.find(params[:id])
    # campaign.destroy
    redirect_to((root_path), flash: {danger: "Campaign removed!"})
  end

      private

        def build_associated_rewards
          number_to_build = REWARD_COUNT - @campaign.rewards.size
          number_to_build.times { @campaign.rewards.build }
        end

        def campaign_params
          params.require(:campaign).permit(:name, :goal, :description, :end_date, :image, {rewards_attributes: [:amount, :title, :id, :_destroy] })
        end

        def find_campaign
          @campaign = Campaign.friendly.find(params[:id]).decorate
        end

        def user_campaign
          @user_campaign ||= current_user.campaigns.friendly.find(params[:id])
        end

end
