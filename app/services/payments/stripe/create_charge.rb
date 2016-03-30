class Payments::Stripe::CreateCharge

  include Virtus.model

  attribute :user, User
  attribute :amount, Integer
  attribute :charge_id, String
  attribute :decription, String

  def call
    charge_customer
  end

  private

    def charge_customer
      begin
        charge = call_stripe_charge_customer
        @charge_id = charge.id
      rescue
        false
      end
    end

    def call_stripe_charge_customer
      Stripe::Charge.create(
                amount: amount,
                currency: "cad",
                customer: user.stripe_customer_id,
                description: "Charge for pledge id: #{pledge.id} "
      )
    end

end
