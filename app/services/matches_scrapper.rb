require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesScrapper

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  attr_reader   :logger, :html_doc
  attr_accessor :count

  def initialize(args = {})
    web_page_scrapper = args[:web_pages_scrapper] || defaults[:web_pages_scrapper]

    @html_doc = web_page_scrapper.call
    @logger ||= Logger.new("#{Rails.root}/log/matches_scraper.log")
  end

  def call
    @count = {all: 0, created: 0, updated: 0, not_changed: 0, errors: 0, new_teams: []}

    parsed = parse_scrapped(html_doc)
    count[:all] = parsed.count
    parsed.each do |record|
      begin
        if record_exists?(record)
          if record_needs_update?(record) 
            binding.pry
            update_record(record)
          else
            count[:not_changed] += 1
          end
        else
          create_record(record)
        end
      rescue StandardError => e
        logger.info "An error of type #{e.class} happened, message is #{e.message}\n\n"
        count[:errors] += 1
      end
    end

    logger.info "\n-------------------------------------------------------
    MATCHES_IN: #{count[:all]}, 
    
    SCRAPPING COMPLETED:
    created     - #{count[:created]}, 
    updated     - #{count[:updated]}, 
    not_changed - #{count[:not_changed]}, 
    errors      - #{count[:errors]}
    
    NEW TEAMS: #{count[:new_teams].flatten} Total: #{count[:new_teams].count}"
  end

  private

  def defaults
    { web_pages_scrapper: WebPagesScrapper.new }
  end

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
    if team# .present?
      team
    else
      count[:new_teams] << args.values
      team = Team.create!(args)
    end
  end

  def create_record(args)
    Match.create!(args)
    count[:created] += 1
  end

  def update_record(args)
    Match.update(args)
    count[:updated] += 1
  end

  def record_needs_update?(args)
    record_exists?(args) && keys_to_update.all? {|k| record(args).send("#{k}").nil?} #&& args[k].present? } # record(args).select {|k,v| keys_to_update.include?(k)}.all? {|k,v| v.nil?}
  end

  def record_exists?(args)    
    record(args).present?
  end

  def record(args)
    keys = args.select {|k,v| keys_find_by.include?(k)} # if args.key?(:score_home) || args.key?(:score_away)
    Match.where(keys).first
  end

  def keys_find_by
    [:home_team, :away_team, :date_time]
  end

  def keys_to_update
    [:score_home, :score_away]
  end

  def dates_match?(date1, date2)
    date1.strftime("%Y-%m-%d %H:%M") == date2.strftime("%Y-%m-%d %H:%M")
  end
end