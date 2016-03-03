class Campaign < ActiveRecord::Base
  has_many :pledges, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: { greater_than_or_equal_to: 10 }

  def to_param

  end

end
