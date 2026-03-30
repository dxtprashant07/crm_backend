FactoryBot.define do
  factory :deal do
    title               { Faker::Commerce.product_name + " Deal" }
    value               { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    stage               { "prospecting" }
    probability         { 10 }
    expected_close_date { 30.days.from_now }
    association         :owner, factory: :user
    contact             { nil }
    company             { nil }

    trait :with_contact do
      association :contact
    end

    trait :with_company do
      association :company
    end

    trait :won do
      stage       { "closed_won" }
      probability { 100 }
    end

    trait :lost do
      stage       { "closed_lost" }
      probability { 0 }
    end

    trait :in_proposal do
      stage       { "proposal" }
      probability { 50 }
    end
  end
end
