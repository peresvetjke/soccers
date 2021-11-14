require 'nokogiri'
require 'open-uri'
require 'pry'

class RatingsScrapper

  attr_reader   :url, :logger
  attr_accessor :result, :errors

  def initialize(url)
    @url = url
    @logger = Logger.new("#{Rails.root}/log/ratings_scraper.log")
    @result = nil
    @errors = []
  end

  def call
    logger.info "Starting scrapping url: #{self.url} ..."
    html_doc = Nokogiri::HTML(URI.open(self.url)) # пробегаем по страницам
    rating_infos = prepare(html_doc)
    self.result = RatingsParser.new(rating_infos).call
    log_results
  end  

  def prepare(html_doc)
    rating_infos = []
    ratings = html_doc.xpath("//tbody//tr")

  end

  def all_pages
    # swith all pages
  end
end