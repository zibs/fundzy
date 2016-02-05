class Campaign < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: { greater_than_or_equal_to: 10 }

end
