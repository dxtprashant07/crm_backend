FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    phone      { Faker::PhoneNumber.phone_number }
    job_title  { Faker::Job.title }
    status     { :lead }
    source     { :website }
    company    { nil }

    trait :with_company do
      association :company
    end

    trait :customer do
      status { :customer }
    end

    trait :prospect do
      status { :prospect }
    end
  end
end
