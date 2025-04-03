# spec/services/cart_abandonment_service_spec.rb
require 'rails_helper'

RSpec.describe CartAbandonmentService do
  include ActiveSupport::Testing::TimeHelpers

  describe '.call' do
    let!(:now) { Time.current }

    let!(:active_cart_recent) do
      create(:cart, abandoned: false, last_interaction_at: now - 2.hours)
    end

    let!(:active_cart_old) do
      create(:cart, abandoned: false, last_interaction_at: now - 4.hours)
    end

    let!(:abandoned_cart_recent) do
      create(:cart, abandoned: true, last_interaction_at: now - 6.days)
    end

    let!(:abandoned_cart_old) do
      create(:cart, abandoned: true, last_interaction_at: now - 8.days)
    end

    before do
      travel_to(now) { described_class.call }
    end

    it 'does not mark recent carts as abandoned' do
      expect(active_cart_recent.reload.abandoned).to eq(false)
    end

    it 'marks carts without activity in the last 3 hours as abandoned' do
      expect(active_cart_old.reload.abandoned).to eq(true)
    end

    it 'does not remove recently abandoned carts' do
      expect(Cart.exists?(abandoned_cart_recent.id)).to be true
    end

    it 'removes carts abandoned for more than 7 days' do
      expect(Cart.exists?(abandoned_cart_old.id)).to be false
    end
  end
end
