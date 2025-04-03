require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'when validating' do
    it 'validates presence of quantity' do
      cart_item = build(:cart_item, quantity: nil)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:quantity]).to include("can't be blank")
    end

    it 'validates numericality of quantity' do
      cart_item = build(:cart_item, quantity: -1)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:quantity]).to include("must be greater than or equal to 1")
    end

    it 'validates presence of product' do
      cart_item = build(:cart_item, product: nil)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:product]).to include("must exist")
    end

    it 'validates presence of cart' do
      cart_item = build(:cart_item, cart: nil)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:cart]).to include("must exist")
    end

  end

  describe 'associations' do
    it 'belongs to a cart' do
      cart_item = create(:cart_item)
      expect(cart_item.cart).to be_present
    end

    it 'belongs to a product' do
      cart_item = create(:cart_item)
      expect(cart_item.product).to be_present
    end
  end
end
