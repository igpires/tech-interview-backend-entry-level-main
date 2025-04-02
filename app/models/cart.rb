class Cart < ApplicationRecord
  ABANDONMENT_THRESHOLD = 3.hours
  REMOVAL_THRESHOLD = 7.days

  validates_numericality_of :total_price, greater_than_or_equal_to: 0


  def mark_as_abandoned
    update(abandoned: true) if last_interaction_at < ABANDONMENT_THRESHOLD.ago
  end

  def remove_if_abandoned
    destroy if abandoned && last_interaction_at < REMOVAL_THRESHOLD.ago
  end
end
