require 'nokogiri'
require 'open-uri'
require 'pry'

class RatingsScrapper

  attr_reader   :url, :logger
  attr_accessor :result, :errors

  def initialize(url = nil)
    @url = url || defaults[:url]
    @logger = Logger.new("#{Rails.root}/log/ratings_scraper.log")
    @result = nil
    @errors = []
  end

  def call
    logger.info "Starting scrapping url: #{self.url} ..."
    html_doc = Nokogiri::HTML(URI.open(self.url))
    rating_infos = prepare(html_doc)
    self.result = RatingsParser.new(rating_infos).call
    log_results
  end  

  private

  def prepare(html_doc)
    rating_infos = []
    ratings = html_doc.xpath(('//table[@class="items"]/tbody/tr'))
    ratings.each do |r|
      title = r.xpath('td[@class="hauptlink"]//a').text
      rating = r.xpath('td[contains(@class, "zentriert")]').text.to_i
      rating_points = r.xpath('td[@class="rechts hauptlink"]//a').text.gsub(/\D/, "").to_i

      rating_infos << {title: title, rating: rating, rating_points: rating_points }
    end
    rating_infos
  end

  def log_results
    logger.info "Scrapping completed! RESULTS: updated_teams - #{self.result[:updated].count}; not_found - #{self.result[:updated].count}} \n Details: #{self.result}"
    if self.errors.present?
      logger.info "!!! ERRORS: #{self.errors.count} \n List: #{self.errors.each_with_index.map{|e, i| "Error #{i+1}" + e.first} }"
    end
    logger.info "------------------------------------------------------------------------"
  end

  def defaults
    {
      url: "https://www.transfermarkt.ru/statistik/klubrangliste"
    }
  end
end