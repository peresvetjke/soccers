FactoryBot.define do
  factory :country do
    title { "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" }
  end
end
