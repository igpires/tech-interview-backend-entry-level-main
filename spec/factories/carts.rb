# spec/factories/carts.rb
FactoryBot.define do
  factory :cart do
    total_price { 0.0 }
    abandoned { false }
    last_interaction_at { Time.current }
  end

  factory :shopping_cart, parent: :cart
end
