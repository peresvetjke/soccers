require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesScrapper

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  attr_reader   :url, :logger
  attr_accessor :result, :errors

  def initialize(url)
    @url = url
    @logger = Logger.new("#{Rails.root}/log/matches_scraper.log")
    @result = nil
    @errors = []
  end

  def call
    logger.info "Starting scrapping url: #{self.url} ..."
    html_doc = Nokogiri::HTML(URI.open(self.url))
    match_infos = prepare(html_doc)
    self.result = MatchesParser.new(match_infos).call
    log_results
  end

  def prepare(html_doc)
    match_infos = []
    matches = html_doc.xpath("//tbody//tr")

    matches.each do |m| 
      begin
        date_time_raw = m.css('td')[0].text
        dt = SPORTS_RU_DATE_PATTERN.match(date_time_raw)
        date_time  = Time.new(dt[:year], dt[:month], dt[:day], dt[:hour], dt[:min])

        home_team_raw = m.css('td')[1].text
        away_team_raw = m.css('td')[3].text

        score_raw = m.css('td')[2].text
        score = SPORTS_RU_SCORE_PATTERN.match(score_raw)
        score_home, score_away = score[:home_score].to_i, score[:away_score].to_i if score.present?
        
        match_infos << {date_time: date_time, home_team: home_team_raw, away_team: away_team_raw, score_home: score_home, score_away: score_away}
      rescue => detail
        self.errors << [m, detail]
      end
    end
    match_infos
  end

  def log_results
    logger.info "Scrapping completed! RESULTS: created_teams - #{self.result[:created_teams].count}; created_matches - #{self.result[:created_matches].count}; updated_matches - #{self.result[:updated_matches].count}
    Details: #{self.result}"
    if self.errors.present?
      logger.info "!!! ERRORS OCURRED: #{self.errors.count}
    Details: 
    #{errors.each_with_index.map{|e, i| "Error #{i+1}" + e.first} }"
    end
    logger.info "------------------------------------------------------------------------"
  end
end