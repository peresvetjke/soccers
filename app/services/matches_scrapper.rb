require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesScrapper

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  attr_reader   :base_url, :logger, :month_from, :month_to
  attr_accessor :result, :errors

  def initialize(args)
    raise ArgumentError if (args[:m_from].nil? || args[:m_to].nil? ) || (args[:m_from] > args[:m_to] || args[:m_from] < -3 || args[:m_to] > 6)

    @base_url = args[:base_url]
    @month_from = args[:m_from] || defaults[:m_from]
    @month_to = args[:m_to] || defaults[:m_to]
    @logger = Logger.new("#{Rails.root}/log/matches_scraper.log")
    @result = nil
    @errors = []
  end

  def call
    self.selected_urls.each do |url|
      logger.info "Starting scrapping url: #{url} ..."
      html_doc = Nokogiri::HTML(URI.open(url))
      match_infos = prepare(html_doc)
      self.result = MatchesParser.new(match_infos).call
      log_results
    end
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

  def defaults
    {
      m_from: 0, # current
      m_to: 2    # two next months
    }
  end

  def selected_urls
    html_doc = Nokogiri::HTML(URI.open(self.base_url))
    month_urls = html_doc.css(".months").css('a')
    actual_month = html_doc.css('.months a.act')[0]
    selected = []

    actual_month_order = month_urls.index(actual_month)
    from, to = self.month_from + actual_month_order, self.month_to + actual_month_order
    month_urls[from..to].each { |month_url| selected << month_url.attr('href') }

    selected
  end
end