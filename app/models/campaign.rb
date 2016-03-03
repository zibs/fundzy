class Campaign < ActiveRecord::Base

  # this integrates FriendlyId within our model
  # we're using the name to generate the `slug`.
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :pledges, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: { greater_than_or_equal_to: 10 }

  # default to_param method
  # def to_param
  #   id
  # end

  # def to_param
    # for to_param to work there must be an ID with non-numerical character right after. It's good to call a method like parameterze which makes it url friendly. for instace, `parameterize` replaces spaces with dashes etc.
    # "#{id}-#{name}".parameterize
  # end

end
