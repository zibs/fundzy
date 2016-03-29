class Campaigns::PublishCampaign
  include Virtus.model

  attribute :campaign, Campaign

  def call
    if campaign.publish!
      DetermineCampaignStateJob.set(wait_until: campaign.end_date).perform_later(campaign)
      true
    else
      false
    end
  end

end
