class Rating < ActiveRecord::Base

  belongs_to :user
  belongs_to :restaurant

  validates :rating, presence: true

  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  before_save :increment_times_had

  RATING_WEIGHT = 1.2
  TIMES_HAD_WEIGHT = -2


  def increment_times_had
    self.times_had += 1
  end

  def calculate_weighted_value
    times_had_weighted_value = TIMES_HAD_WEIGHT * times_had > -10 ? TIMES_HAD_WEIGHT - times_had : -10

    times_had_weighted_value - (RATING_WEIGHT * rating)
  end
end
