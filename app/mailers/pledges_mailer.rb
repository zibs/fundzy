class PledgesMailer < ApplicationMailer
  def notify_user_upon_pledge(pledge)
    @campaign = pledge.campaign
    @owner    = @campaign.user
    @pledge   = pledge
    mail(to: @owner.email, subject: "Someone Pledged to Your Campaign!")
  end
end
