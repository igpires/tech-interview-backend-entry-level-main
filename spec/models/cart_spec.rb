require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = build(:cart, :with_negative_price)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let(:cart) { create(:cart, :inactive_for_3_hours) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      expect { cart.mark_as_abandoned }.to change { cart.abandoned? }.from(false).to(true)
    end
  end

  describe 'remove_if_abandoned' do
    let!(:cart) { create(:cart, :inactive_for_7_days) }

    it 'removes the shopping cart if abandoned for a certain time' do
      cart.mark_as_abandoned
      expect { cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end
  end
end
