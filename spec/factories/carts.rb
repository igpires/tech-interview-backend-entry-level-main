FactoryBot.define do
  factory :cart do
    total_price { 0.0 }
    abandoned { false }
    last_interaction_at { Time.current }

    trait :with_negative_price do
      total_price { -1 }
    end

    trait :inactive_for_3_hours do
      last_interaction_at { Cart::ABANDONMENT_THRESHOLD.ago }
    end

    trait :inactive_for_7_days do
      last_interaction_at { Cart::REMOVAL_THRESHOLD.ago }
    end

  end

end
