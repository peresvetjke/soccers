class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id" 
  belongs_to :league
  
  validates :home_team, :away_team, :date_time, presence: true

  default_scope { Match.order(date_time: :desc) }

  def self.top(rating)
    teams = Team.top(rating)
    Match.where(home_team: teams, away_team: teams)
  end

  def self.matches_by_team(team)
    Match.where(home_team: team).or(Match.where(away_team: team))
  end

  def self.matches_of_favorites_by_user(user)
    teams = Team.where(id: user.favorite_teams.ids)
    self.matches_by_team(teams)
  end
end
