FactoryBot.define do
  factory :context do
    vault
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    autotag { [true, false].sample }
  end
end