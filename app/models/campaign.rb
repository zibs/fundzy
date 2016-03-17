class Campaign < ActiveRecord::Base

  # this integrates FriendlyId within our model
  # we're using the name to generate the `slug`.
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  # mount the uploader. :image is a field in the DB that stores the image name. Uploader is the uploader class that was generated with carrierwave.
  mount_uploader :image, ImageUploader
  # associate
  has_many :pledges, dependent: :destroy
  has_many :rewards, dependent: :destroy
  # allblank means that empty will be ignored for validations
  # destroy lets us pass us in value true destory param to destory the obejct
  accepts_nested_attributes_for :rewards, reject_if: :all_blank, allow_destroy: true

  belongs_to :user
  # validate
  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: { greater_than_or_equal_to: 10 }

  geocoded_by :address   # can also be an IP address in which means we don't need to request permissions
  after_validation :geocode          # auto-fetch coordinates
  # uses google to find/store coordinates

  include AASM
  # setting whiny_transistions false options makes it so it won't throw an exception when an invalid transition happens.

  aasm whiny_transitions: false do
    # Campaign.all.map(&:save) to make all be updated as draft
    state :draft, initial: true
    state :published
    state :funded
    state :unfunded
    state :cancelled
    # events are used to transition from one state to another.
    # verbs are used as events as they `do` things
    event :publish do
      transitions from: :draft, to: :published
    end

    event :fund do
      transitions from: :published, to: :funded
    end

    event :unfund do
      transitions from: :published, to: :unfunded
    end

    event :cancel do
      transitions from: [:draft, :published, :funded], to: :cancelled
    end
  end

  def published
    where(aasm_state: :published)
  end
  # default to_param method
  # def to_param
  #   id
  # end

  # def to_param
    # for to_param to work there must be an ID with non-numerical character right after. It's good to call a method like parameterze which makes it url friendly. for instace, `parameterize` replaces spaces with dashes etc.
    # "#{id}-#{name}".parameterize
  # end
  # >

end
