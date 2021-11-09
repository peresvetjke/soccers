require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesScrapper

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  attr_reader   :logger, :html_doc
  attr_accessor :count

  def initialize(web_page_scrapper)
    @html_doc = web_page_scrapper.call
    @logger ||= Logger.new("#{Rails.root}/log/matches_scraper.log")
    @count = {all: 0, created: 0, updated: 0, errors: 0, new_teams: []}
  end

  def call
    parsed = parse_scrapped(html_doc)
    count[:all] = parsed.count
    parsed.each do |record|
      begin
        if record_exists?(record)
          if record_needs_update?(record)
            count[:updated] += 1 if update_record(record)
          end
        else
          create_record(record)
          count[:created] += 1
        end
      rescue StandardError => e
        logger.info "An error of type #{e.class} happened, message is #{e.message}\n\n"
        count[:errors] += 1
      end
    end
    logger.info "\n-------------------------------------------------------
    SCRAPPING COMPLETED. IN: #{count[:all]}, NEW RECORDS: #{count[:created]}, UPDATED: #{count[:updated]}, ERRORS: #{count[:errors]}\n
    NEW TEAMS: #{count[:new_teams].flatten} Total: #{count[:new_teams].count}"
  end

  private

  def parse_scrapped(html_doc)
    parsed_records = []
    
    matches = html_doc.xpath("//tbody//tr")
    matches.each do |m| 
      date_pattern = SPORTS_RU_DATE_PATTERN
      date_time_raw = m.css('td')[0].text
      dt = date_pattern.match(date_time_raw)
      date_time  = Time.new(dt[:year], dt[:month], dt[:day], dt[:hour], dt[:min])

      home_team_raw = m.css('td')[1].text
      home_team = find_or_create_team({title: home_team_raw})

      away_team_raw = m.css('td')[3].text
      away_team = find_or_create_team({title: away_team_raw})

      score_pattern = SPORTS_RU_SCORE_PATTERN
      score_raw = m.css('td')[2].text
      score = score_pattern.match(score_raw)
      score_home, score_away = score[:home_score].to_i, score[:away_score].to_i if score.present?
      
      parsed_records << {date_time: date_time, home_team: home_team, away_team: away_team, score_home: score_home, score_away: score_away}
    end
    parsed_records
  end

  def find_or_create_team(args)
    team = Team.find_by(args)
    if team
      home_team = team
    else
      count[:new_teams] << args.values
      team = Team.create!(args)
    end
  end

  def create_record(args)
    Match.create!(args)
  end

  def update_record(args)
    Match.update(args)
  end

  def record_exists?(args)
    args = args.except(:score_home, :score_away) # if args.key?(:score_home) || args.key?(:score_away)
    Match.where(args).present?
  end

  def record_needs_update?(args)
    record_exists?(args) && args[:score_home].present? && args[:score_away].present?
  end

end