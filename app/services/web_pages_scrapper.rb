require 'nokogiri'
require 'open-uri'
require 'pry'

class WebPagesScrapper

  MATCH_SCHEDULE_URLS = {
                          UCL:      "https://www.sports.ru/ucl/calendar/",
                          EPL:      "https://www.sports.ru/epl/calendar/",
                          La_liga:  "https://www.sports.ru/la-liga/calendar/"
                        }
  
  attr_reader :html_file_path, :url

  def initialize(args = {})
    @html_file_path = args[:html_file_path]
    @url = args[:url]  || defaults[:url]
  end

  def call
    if @html_file_path.present?
      scrap_file(@html_file_path)
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

  def scrap_file(html_file_path)
    Nokogiri::HTML(File.read(html_file_path))
  end

  def scrap_web_page(url)
    Nokogiri::HTML(URI.open(url))
  end
end