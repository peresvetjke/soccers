require 'nokogiri'
require 'open-uri'

class MatchesParser

  attr_reader   :match_infos, :league
  attr_accessor :result

  def initialize(args)
    # binding.pry
    @league = args[:league]
    @match_infos = args[:match_infos]
    @result = { created_teams: [], created_matches: [], updated_matches: [] }
  end

  def call
    match_infos.each do |match_info|
      date_time  = match_info[:date_time] 
      home_team  = Team.find_or_initialize_by(title: match_info[:home_team])
      away_team  = Team.find_or_initialize_by(title: match_info[:away_team])
      score_home = match_info[:score_home]
      score_away = match_info[:score_away]
      league     = match_info[:league]

      [home_team, away_team].each do |team| 
        if team.new_record?
          team.save!
          result[:created_teams] << team.id
        end
      end

      match = Match.find_or_initialize_by(home_team_id: home_team.id, away_team_id: away_team.id, date_time: date_time, league_id: self.league.id)
      match.assign_attributes(score_home: score_home, score_away: score_away)
      if match.new_record?
        match.save!
        result[:created_matches] << match.id
      else
        if match.changed?
          match.save!
          result[:updated_matches] << match.id
        end
      end
    end
    result
  end
end

=begin
    [
      {:date_time=>Time.new(2021,11,02,20,45), :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>nil, :score_away=>nil}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>nil, :score_away=>nil}
    ]
=end