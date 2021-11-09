FactoryBot.define do
  factory :match do
    home_team_id { 1 }
    away_team_id { 1 }
    date_time { "MyString" }
    score_home { 1 }
    score_away { 1 }

    trait "no_score" do
      score_home { nil }
      score_away { nil }      
    end
  end
end
