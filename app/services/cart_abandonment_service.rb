class CartAbandonmentService
  def self.call
    new.call
  end

  def call
    now = Time.current

    mark_abandoned_carts(now)
    remove_old_abandoned_carts(now)
  end

  private

  def mark_abandoned_carts(timestamp)
    Cart.where(abandoned: false)
        .where('last_interaction_at < ?', timestamp - 3.hours)
        .update_all(abandoned: true, updated_at: timestamp)
  end

  def remove_old_abandoned_carts(timestamp)
    Cart.where(abandoned: true)
        .where('last_interaction_at < ?', timestamp - 7.days)
        .destroy_all
  end
end
