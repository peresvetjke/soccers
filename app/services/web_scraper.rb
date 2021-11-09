class WebScraper

  def initialize
    @logger ||= Logger.new("#{Rails.root}/log/matches_loader.log")
  end

  def call
    scrapped = []
    urls.each { |url| scrapped << scrap_html(url) }
    
    parsed = parse_scrapped(scrapped)
    parsed.each do |record|
      if record_exists?(record)
        update_record(record) if record_needs_update?(record)
      else
        create_record(record)
      end
    end
  end

  private

  def scrap_html(url)
    doc = Nokogiri::HTML(URI.open(url))
    scrapped = []

    matches = doc.xpath("//tbody//tr")
    matches.each do |m| 
      # проверить выполнение парс здесь  
      date_time = m.css('td')[0].text
      home_team = m.css('td')[1].text
      score     = m.css('td')[2].text
      away_team = m.css('td')[3].text
      
      scrapped << {date_time: date_time, home_team: home_team, score: score, away_team: away_team}
    end
    scrapped
  end

  def parse_scrapped(scrapped)
    scrapped.each do |s|
    end
  end # => records created or updated

  def create_record(record)
  end

  def update_record(record)
  end

  def record_exists?(record)
  end

  def record_needs_update?(record)

  end

  def urls
    []
  end

end