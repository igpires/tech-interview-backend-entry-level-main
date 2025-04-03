class CartManager
  attr_reader :cart

  def initialize(session)
    @session = session
    @cart = find_or_create_cart
  end

  def add_product(product_id, quantity)
    product = Product.find(product_id)
    item = cart.cart_items.find_or_initialize_by(product_id: product.id)

    item.quantity ||= 0
    item.quantity += quantity
    item.save!

    touch_cart!
  end

  def remove_product(product_id)
    item = cart.cart_items.find_by(product_id: product_id)
    raise ActiveRecord::RecordNotFound, 'Produto não encontrado no carrinho' unless item

    item.destroy!
    touch_cart!
  end

  def serialize
    products = serialized_products
    {
      id: cart.id,
      products: products,
      total_price: products.sum { |p| p[:total_price] }
    }
  end

  private

  def find_or_create_cart
    Cart.find_by(id: @session[:cart_id]) || create_cart
  end

  def create_cart
    cart = Cart.create!(total_price: 0, last_interaction_at: Time.current)
    @session[:cart_id] = cart.id
    cart
  end

  def touch_cart!
    @cart.update!(last_interaction_at: Time.current)
  end

  def serialized_products
    cart.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price.to_f,
        total_price: (item.quantity * item.product.price).to_f
      }
    end
  end
end
