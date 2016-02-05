require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  describe "validations" do
    # every test scenario must be put with an 'it' or 'specify' block
    # it is a method that takes a test example description and a block of code
    # where you can construct your test.
    it "doesn't allow creating a campaign with no name" do
      # GIVEN
      c = Campaign.new
      # WHEN: we validate the campaign
      campaign_valid = c.valid?
      # THEN: expect that campagin_valid should be false
      expect(campaign_valid).to eq(false)
      # rspec_expectation obj which has method .to which takes another argument.
    end

    it "requires a goal" do
          # GIVEN:
      c = Campaign.new
      # WHEN
      c.valid?
      # THEN
      # errors is a hash -- key is attr error, value is array of messages
      expect(c.errors).to have_key(:goal)
      # have_key is
    end

    it "requires a goal that is more than 10" do
      c = Campaign.new(goal: 6)
      # WHEN
      c.valid?
      # THEN
      expect(c.errors).to have_key(:goal)
      # expect(c.errors[:goal]).to include?("must be")
    end

    it "requires a unique name" do
      # GIVEN
      # c = Campaign.new(name: "abc", goal: 15)
      # c.save
      Campaign.create({name: "abc", goal: 15, description: "abc"})
      b = Campaign.new(name: "abc", goal: 15)
      # WHEN
      b.save
      # THEN
      expect(b.errors).to have_key(:name)
    end

  end
end
