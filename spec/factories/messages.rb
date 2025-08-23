FactoryBot.define do
  factory :message, class: 'Entry::Message' do
    text { Faker::Lorem.paragraph }
  end
end
