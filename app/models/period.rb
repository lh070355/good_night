class Period < ApplicationRecord
  LONGEST_SLEEPING_DAYS = 11
  # let constant be private for not let others alter this value
  private_constant :LONGEST_SLEEPING_DAYS

  validates :user_id, presence: true
  validates :sleep_time, presence: true
  validates :wake_up_time, comparison: { greater_than_or_equal_to: :sleep_time }, allow_nil: true
  # set this validation because normal people won't sleep over 11 days.
  validates :duration,
            numericality: { less_than_or_equal_to: LONGEST_SLEEPING_DAYS.days.in_seconds },
            allow_nil: true

  # even if the user is deregistered, their periods can still be saved for future analysis if no
  # concern in privacy and storage space
  belongs_to :user, optional: true

  # use class method instead of constant for accessing outsite this class because constant might be
  # changed if not handled properly
  def self.longest_sleeping_days
    LONGEST_SLEEPING_DAYS
  end

  # return false if the wake_up time of the last record is not clock-in and the sleep time of it is
  # within longest sleeping days
  def ongoing?(current_time = DateTime.current)
    wake_up_time.nil? && current_time.before?(sleep_time.days_since(LONGEST_SLEEPING_DAYS))
  end
end
