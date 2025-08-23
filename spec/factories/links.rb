FactoryBot.define do
  factory :link do
    url { Faker::Internet.url }
    title { Faker::Lorem.sentence }
  end
end
