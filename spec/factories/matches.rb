FactoryBot.define do
  factory :match do
    home_team { create(:team) }
    away_team { create(:team) }
    date_time { Time.new(2021,11,01,17,00) }
    score_home { 2 }
    score_away { 1 }

    trait "no_score" do
      score_home { nil }
      score_away { nil }      
    end
  end
end
