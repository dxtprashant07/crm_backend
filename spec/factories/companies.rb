FactoryBot.define do
  factory :company do
    name     { Faker::Company.unique.name }
    industry { Faker::Company.industry }
    website  { Faker::Internet.url }
    phone    { Faker::PhoneNumber.phone_number }
    city     { Faker::Address.city }
    country  { "India" }
    size     { :medium }
  end
end
