require 'rails_helper'

RSpec.describe "/cart", type: :request do
  describe "GET /cart" do
    context "when the cart is empty" do
      it "returns an empty list of products" do
        get '/cart'
        body = JSON.parse(response.body)
        expect(body["products"]).to eq([])
        expect(body["total_price"]).to eq(0)
      end
    end

    context "when the cart has products" do
      let!(:product) { create(:product, name: "Ruby Book", price: 50.0) }

      before do
        post '/cart/add_item',
          params: { product_id: product.id, quantity: 2 },
          as: :json
      end

      it "returns the products and correct total" do
        get '/cart'
        body = JSON.parse(response.body)

        expect(body["products"].first["name"]).to eq("Ruby Book")
        expect(body["products"].first["quantity"]).to eq(2)
        expect(body["total_price"]).to eq(100.0)
      end
    end

  end

  describe "POST /cart" do
    context "when the the product does not exist" do
      it "returns a 404 error" do
        post '/cart',
          params: { product_id: -1, quantity: 1 },
          as: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the product exists" do
      let!(:product) { create(:product, name: "Ruby Book", price: 50.0) }

      it "creates a new cart" do
        post '/cart',
          params: { product_id: product.id, quantity: 2 },
          as: :json

        body = JSON.parse(response.body)

        expect(body["products"].first["name"]).to eq("Ruby Book")
        expect(body["products"].first["quantity"]).to eq(2)
        expect(body["total_price"]).to eq(100.0)
      end
    end
  end

  describe "POST /cart/add_item" do
    let!(:product_a) { create(:product) }
    let!(:product_b) { create(:product) }

    context 'when the product already is in the cart' do
      it 'updates the quantity of the existing item in the cart' do
        expect_cart_to_be_empty

        add_product(product_a, 1)
        expect_cart_to_have product_a => 1
        add_product(product_a, 2)
        expect_cart_to_have product_a => 3

        add_product(product_b, 1)
        expect_cart_to_have product_a => 3, product_b => 1
        add_product(product_b, 2)
        expect_cart_to_have product_a => 3, product_b => 3
      end
    end

    def add_product(product, quantity)
      post '/cart/add_item',
            params: { product_id: product.id, quantity: quantity },
            as: :json
    end

    def expect_cart_to_have(mapping={})
      get '/cart'
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      # {"id"=>3, "products"=>[{"id"=>1, "name"=>"Valid Product", "quantity"=>2, "unit_price"=>10.0, "total_price"=>20.0}], "total_price"=>20.0}
      actual_cart = response_body["products"].map { [_1["id"], _1["quantity"]] }
      expected_cart = mapping.map { [_1.id, _2] }
      expect(actual_cart).to eq(expected_cart)
    end

    def expect_cart_to_be_empty
      expect_cart_to_have
    end
  end

  describe "DELETE /cart/:product_id" do
    context "when the product is not in the cart" do
      it "returns a 404 error" do
        delete '/cart/-1'
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the product is in the cart" do
      let!(:product) { create(:product, name: "Ruby Book", price: 50.0) }

      before do
        post '/cart/add_item',
          params: { product_id: product.id, quantity: 2 },
          as: :json
      end

      it "removes the product from the cart" do
        delete "/cart/#{product.id}"
        body = JSON.parse(response.body)

        expect(body["products"]).to eq([])
        expect(body["total_price"]).to eq(0)
      end
    end
  end

end
