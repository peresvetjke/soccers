FactoryBot.define do
  factory :team do
    title { "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" }
    association :country

  end
end
