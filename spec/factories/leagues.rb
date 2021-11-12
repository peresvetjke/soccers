FactoryBot.define do
  factory :league do
    title
    association :country, factory: :country
  end
end
