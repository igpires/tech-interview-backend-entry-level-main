FactoryBot.define do
  factory :product do
    name { "Produto Padrão" }
    price { 9.99 }

    trait :without_name do
      name { nil }
    end

    trait :without_price do
      price { nil }
    end

    trait :with_negative_price do
      price { -10 }
    end
  end
end
