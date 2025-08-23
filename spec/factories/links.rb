FactoryBot.define do
  factory :link, class: 'Entry::Link' do
    url { Faker::Internet.url }
    title { Faker::Lorem.sentence }
  end
end
