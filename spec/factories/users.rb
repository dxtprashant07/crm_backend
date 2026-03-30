FactoryBot.define do
  factory :user do
    name     { Faker::Name.full_name }
    email    { Faker::Internet.unique.email }
    password { "password123" }
    role     { :agent }
    active   { true }

    trait :admin   { role { :admin } }
    trait :manager { role { :manager } }
    trait :agent   { role { :agent } }
  end
end
