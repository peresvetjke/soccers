require 'nokogiri'
require 'open-uri'
require 'pry'

class WebPagesScrapper

  MATCH_SCHEDULE_URLS = {
                          UCL:      "https://www.sports.ru/ucl/calendar/",
                          EPL:      "https://www.sports.ru/epl/calendar/",
                          La_liga:  "https://www.sports.ru/la-liga/calendar/"
                        }
  
  attr_reader :file, :url, :logger

  def initialize(args)
    @file = args[:file]
    @url = args[:url]  || defaults[:url]
    @logger ||= Logger.new("#{Rails.root}/log/matches_scraper.log")
  end

  def call
    if @file.present?
      scrap_file(@file)
    else
      scrap_web_page(@url)
    end
  end

  private

  def defaults
    {
      url: MATCH_SCHEDULE_URLS[:UCL]
    }
  end

  def scrap_file(file)
    Nokogiri::HTML(file)
  end

  def scrap_web_page(url)
    Nokogiri::HTML(URI.open(url))
  end

end