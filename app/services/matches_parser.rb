require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesParser

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  def initialize
  end

  def call(match_infos)
    result = { created_teams: [], created_matches: [], updated_matches: [] }

    match_infos.each do |match_info|
      date_time  = match_info[:date_time] 
      home_team  = Team.find_or_initialize_by(title: match_info[:home_team])
      away_team  = Team.find_or_initialize_by(title: match_info[:away_team])
      score_home = match_info[:score_home]
      score_away = match_info[:score_away]

      [home_team, away_team].each do |team| 
        if team.new_record?
          team.save!
          result[:created_teams] << team.id
        end
      end

      match = Match.find_or_initialize_by(home_team_id: home_team.id, away_team_id: away_team.id, date_time: date_time)
      if match.new_record?
        match.save!
        result[:created_matches] << match.id
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