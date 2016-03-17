class User < ActiveRecord::Base
  has_secure_password

  has_many :campaigns, dependent: :nullify
  has_many :pledges, dependent: :destroy

  # validate :password_length

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validate :password_length
  # validates :password, length: { minimum: 6 }, on: :create
  validates :first_name, presence: true
  validates :email, presence: true,
            uniqueness: true,
            format: VALID_EMAIL_REGEX

  geocoded_by :address
  after_validation :geocode
# Campaign.where.not(latitude: nil).count
# Campaign.limit(100).each { |c| c.update(address: a.sample) }

  def full_name
    "#{first_name} #{last_name}".strip.titleize
  end

    private

      def password_length
        if password.present? && password.length >= 6
          true
        else
          errors.add(:password, "Password must be longer than 6 characters")
          # false
          # use false if doing a before_update callback
        end
      end

end
