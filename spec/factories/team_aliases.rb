FactoryBot.define do
  factory :team_alias do
    association :team
    title { "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" }
    default { false }
  end
end
