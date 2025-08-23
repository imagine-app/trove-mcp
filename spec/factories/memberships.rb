FactoryBot.define do
  factory :membership do
    user
    vault
    role { :reader }

    trait :manager do
      role { :manager }
    end
  end
end