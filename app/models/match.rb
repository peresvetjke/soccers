class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id" 

  validates :home_team, :away_team, :date_time, presence: true

  def self.matches_by_team(team)
    Match.where(home_team: team).or(Match.where(away_team: team))
  end

  def self.accept!(args)
    match_record = self.find_by(home_team_id: args[:home_team_id], away_team_id: args[:away_team_id], date_time: args[:date_time]) || self.create!(args)
    if match_record.score_home != args[:score_home] || match_record.score_away != args[:score_away]
      match_record.update(score_home: args[:score_home], score_away: args[:score_away])
    end
  end
end
