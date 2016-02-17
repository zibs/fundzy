require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { FactoryGirl.create(:user)}
  # FactoryGirl.attributes_for(:user)
    describe "Validations" do

      it "requires a first name" do
        # GIVEN:
        u = User.new
        # WHEN: validating the record
        u.valid?
        # THEN:
        expect(u.errors).to have_key(:first_name)
      end
      it "requires a email" do
        u = User.new
        u.valid?

        expect(u.errors).to have_key(:email)
      end
      it "reqiures a password" do
        u = User.new
        u.valid?
        expect(u.errors).to have_key(:password)
      end

      it "requires a unique email" do
        # u = User.new(first_name: "eli", last_name: "zibin", email: "eli@eli.com", password: "123123", password_confirmation: "123123")
        # u.save

        user_two = User.new(email: user.email)
        user_two.valid?
        # u2 = User.new(first_name: "eli", last_name: "zibin", email: "eli@eli.com", password: "123123", password_confirmation: "123123")
        # u2.valid?
        expect(user_two.errors).to have_key(:email)
      end

    end

    describe ".full_name"  do

      it "concatenates the first name and the last name" do
        # u = User.create(first_name: "eli", last_name: "zibin", email: "eli@eli.com", password: "123123", password_confirmation: "123123")
        # this is a more generic way of writing the test to just check if these are present
        # titleize will still work with include
        # user = FactoryGirl.build(:user) -- saves it in memory
        expect(user.full_name).to include("#{user.first_name}", "#{user.last_name}")
      end

      it "returns first name if the last name is missing" do
        # u = User.create(first_name: "eli", email: "eli@eli.com", password: "123123", password_confirmation: "123123")
        u = FactoryGirl.build(:user, {last_name: nil})
        expect(u.full_name).to eq("#{u.first_name}")
      end

    end

    describe "password generating" do

      it "generates a password digest on creation" do
        # u = User.create(first_name: "eli", last_name: "zibin", email: "eli@eli.com", password: "123123", password_confirmation: "123123")
        expect(user.password_digest).to be
      end

    end


end
