class Campaigns::CreateCampaign
  include Virtus.model

  attribute :params, Hash
  attribute :user, User
  # this is the campaign taht gets created. We may need it for things scuh as error messages and rebuilding the form with the errors.
  attribute :campaign, Campaign

  def call
    self.campaign = Campaign.new(params)
    campaign.user = user
    campaign.save
  end


end
