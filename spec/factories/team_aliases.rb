FactoryBot.define do
  factory :team_alias do
    association :team
    title
    default { false }
  end
end
