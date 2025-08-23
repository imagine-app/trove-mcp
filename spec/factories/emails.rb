FactoryBot.define do
  factory :email do
    mailbox
    to { Faker::Internet.email }
    from { Faker::Internet.email }
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    received_at { Faker::Time.backward(days: 7) }
  end
end
