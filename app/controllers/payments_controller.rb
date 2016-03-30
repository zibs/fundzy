class PaymentsController < ApplicationController
  before_action :authenticate_user
  before_action :find_pledge

  def new
    @pledge = current_user.pledges.find(params[:pledge_id])
  end

  def create
    service = Payments::HandlePayment.new(user: current_user,
                                  stripe_token: params[:stripe_token], pledge: @pledge)
    if service.call
      redirect_to @pledge.campaign, flash: {success: "pledged"}
    else
      render :new
    end
  end

  private
    def find_pledge
      @pledge = current_user.pledges.find(params[:pledge_id])
    end

end
