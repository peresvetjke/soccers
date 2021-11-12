class Match < ApplicationRecord
  belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id" 

  validates :home_team, :away_team, :date_time, presence: true

  def self.matches_by_team(team)
    Match.where(home_team: team).or(Match.where(away_team: team))
  end

  def self.accept!(args)
    # checks if match exists
    match_record = self.find_by(home_team_id: args[:home_team], away_team_id: args[:away_team], date_time: args[:date_time])
    self.create!(args) unless match_record.present?
  end

  #def self.find_by(args)
  #  keys = args.select {|k,v| keys_find_by.include?(k)} # if args.key?(:score_home) || args.key?(:score_away)
  #  Match.where(keys).first
  #end
end
