class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id" 

  validates :home_team, :away_team, :date_time, presence: true

  def self.matches_by_team(team)
    Match.where(home_team: team).or(Match.where(away_team: team))
  end
end
