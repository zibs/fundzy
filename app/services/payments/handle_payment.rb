class Payments::HandlePayment
  include Virtus.model

  attribute :user, User
  attribute :stripe_token, String
  attribute :pledge, Pledge

  def call
    create_customer && create_charge_for_customer
    update_pledge
    # redirect_to pledge.campaign, notice: "Thanks for completing the payment"
    # render text: "Got the token #{params[:stripe_token]}"
  end

private

    def update_pledge
      pledge.stripe_txn_id = charge.id
      pledge.save
    end

    def create_customer
      customer_service = Payments::Stripe::CreateCustomer.new(user: user, stripe_token: stripe_token)
      customer_service.call
    end

    def create_charge_for_customer
      begin
        charge
      rescue => e
        false
      end
    end

    def charge
      @charge ||= Stripe::Charge.create(
                amount: pledge.amount * 100,
                currency: "cad",
                customer: user.stripe_customer_id,
                description: "Charge for pledge id: #{pledge.id} "
      )
    end
end
