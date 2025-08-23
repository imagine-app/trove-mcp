FactoryBot.define do
  factory :message do
    text { Faker::Lorem.paragraph }
  end
end