class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id" 
  belongs_to :league
  has_many   :tracked_matches
  
  validates :home_team, :away_team, :date_time, presence: true

  default_scope { Match.order(date_time: :desc) }
  scope :tracked_by_user, -> (user) { joins(:tracked_matches).where('tracked_matches.user_id = ?', user.id) }

  def add_to_tracked(user)
    TrackedMatch.create(match: self, user: user)
  end

  def tracked?(user)
    TrackedMatch.find_by(match:self, user: user).present?
  end

  def remove_from_tracked(user)
    TrackedMatch.find_by(match: self, user: user).destroy
  end

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

  def self.with_titles(matches)
    matches.map do |match|
      { league_title: match.league.title, date_time: match.date_time.strftime("%Y-%m-%d %H:%M"), home_team_title: match.home_team.title, away_team_title: match.away_team.title, score_home: match.score_home, score_away: match.score_away }
    end
  end
end
