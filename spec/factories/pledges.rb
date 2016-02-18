FactoryGirl.define do
  factory :pledge do
    # This will automatically create a campaign record and associate a pledge record with it, if you don't pass a campaign to the pledge factory.
    association :campaign, factory: :campaign
    association :user, factory: :user
    # create(:pledge) will auto associate with a new campaign
    # or
    # FactoryGirl.create(:pledge, {campaign: Campaign.first})
    amount { 1 + rand(1000) }
  end
end
