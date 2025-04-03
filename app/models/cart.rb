class Cart < ApplicationRecord
  # Constants
  ABANDONMENT_THRESHOLD = 3.hours
  REMOVAL_THRESHOLD = 7.days

  # Associations
  has_many :cart_items, dependent: :destroy

  # Validations
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  # class methods
  def mark_as_abandoned
    update(abandoned: true) if last_interaction_at < ABANDONMENT_THRESHOLD.ago
  end

  def remove_if_abandoned
    destroy if abandoned && last_interaction_at < REMOVAL_THRESHOLD.ago
  end
end
