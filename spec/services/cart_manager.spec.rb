require 'rails_helper'

RSpec.describe CartManager, type: :service do
  let(:session) { {} }
  let(:manager) { described_class.new(session) }
  let(:product) { create(:product, price: 10.0) }

  describe '#initialize' do
    it 'creates a new cart if cart_id is not present in the session' do
      expect { manager }.to change(Cart, :count).by(1)
      expect(session[:cart_id]).to eq(manager.cart.id)
    end
  end

  describe '#add_product' do
    context 'when the product is not in the cart' do
      it 'adds a new cart item with the correct quantity' do
        expect {
          manager.add_product(product.id, 2)
        }.to change { manager.cart.cart_items.count }.by(1)

        item = manager.cart.cart_items.first
        expect(item.product_id).to eq(product.id)
        expect(item.quantity).to eq(2)
      end
    end

    context 'when the product already exists in the cart' do
      it 'updates the cart item quantity' do
        manager.add_product(product.id, 1)
        manager.add_product(product.id, 3)

        item = manager.cart.cart_items.first
        expect(item.quantity).to eq(4)
      end
    end
  end

  describe '#remove_product' do
    context 'when the product is in the cart' do
      it 'removes the product from the cart' do
        manager.add_product(product.id, 1)
        expect {
          manager.remove_product(product.id)
        }.to change { manager.cart.cart_items.count }.by(-1)
      end
    end

    context 'when the product is not in the cart' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          manager.remove_product(product.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#serialize' do
    it 'returns a hash with serialized cart information' do
      manager.add_product(product.id, 2)
      result = manager.serialize

      expect(result[:id]).to eq(manager.cart.id)
      expect(result[:products].first[:id]).to eq(product.id)
      expect(result[:products].first[:quantity]).to eq(2)
      expect(result[:total_price]).to eq(20.0)
    end
  end
end
