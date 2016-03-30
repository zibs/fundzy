class Payments::Stripe::CreateCustomer
  include Virtus.model

  attribute :user, User
  attribute :stripe_token, String

  # this `call` method will invoke call_stripe_customer create method which will return the created stripe customer, or return false. If it doesn't return false, it will execute `save_user_data` which will use the stripe customer information to store in the user record
  
  def call
     call_stripe_custemer_create && save_user_data
  end

  private

  def call_stripe_custemer_create
    begin
      stripe_customer
    rescue => e
      # maybe you want to email admin with the error
      false
    end
  end

  def save_user_data
    user.stripe_customer_id       = stripe_customer.id
    user.stripe_last_4            = stripe_customer.sources.data[0].last4
    user.stripe_card_type         = stripe_customer.sources.data[0].brand
    user.stripe_card_expiry_month = stripe_customer.sources.data[0].exp_month
    user.stripe_card_expiry_year  = stripe_customer.sources.data[0].exp_year

    user.save
  end

  def stripe_customer
    @stripe_customer||= Stripe::Customer.create(
                        description: "Customer is #{user.email}",
                        source: stripe_token
                      )
  end

end
