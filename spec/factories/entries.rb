FactoryBot.define do
  factory :entry do
    vault
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }

    trait :with_email do
      entriable { association(:email) }
    end

    trait :with_message do
      entriable { association(:message) }
    end

    trait :with_link do
      entriable { association(:link) }
    end
  end
end
