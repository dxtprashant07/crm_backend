FactoryBot.define do
  factory :activity do
    activity_type { "call" }
    subject       { Faker::Lorem.sentence(word_count: 4) }
    description   { Faker::Lorem.paragraph }
    completed     { false }
    scheduled_at  { 1.day.from_now }
    association   :user
    contact       { nil }
    deal          { nil }

    trait :call    { activity_type { "call" } }
    trait :email   { activity_type { "email" } }
    trait :meeting { activity_type { "meeting" } }
    trait :note    { activity_type { "note" } }
    trait :task    { activity_type { "task" } }
    trait :done    { completed { true } }

    trait :with_contact do
      association :contact
    end

    trait :with_deal do
      association :deal
    end
  end
end
