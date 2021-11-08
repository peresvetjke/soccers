require 'nokogiri'
require 'open-uri'
require 'pry'

class MatchesLoader

  MATCH_SCHEDULE_URLS = {
                          UCL:      "https://www.sports.ru/ucl/calendar/",
                          EPL:      "https://www.sports.ru/epl/calendar/",
                          La_liga:  "https://www.sports.ru/la-liga/calendar/"
                        }

  SPORTS_RU_DATE_PATTERN  = /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
  SPORTS_RU_SCORE_PATTERN = /(?<home_score>\d+)\s*\:\s*(?<away_score>\d+)/

  def initialize
    @logger ||= Logger.new("#{Rails.root}/log/matches_loader.log")
  end

  def call
    match_infos = scrape_match_schedules
    create_matches(match_infos)
  end

  private

  def scrape_match_schedules
    # urls = scrape_months_urls
    epl_url = MATCH_SCHEDULE_URLS[:EPL]
    doc = Nokogiri::HTML(URI.open(epl_url))

    # for each month ..
    match_infos = []
    matches = doc.xpath("//tbody//tr")
    matches.each do |m| 
      # проверить выполнение парс здесь  
      date_time = m.css('td')[0].text
      home_team = m.css('td')[1].text
      score     = m.css('td')[2].text
      away_team = m.css('td')[3].text
      
      match_infos << {date_time: date_time, home_team: home_team, score: score, away_team: away_team}
    end
    match_infos
  end

  def create_matches(match_infos)
    count_all = match_infos.count
    count_created = 0

    match_infos.each do |m_info|
      date_pat = SPORTS_RU_DATE_PATTERN
      dt = date_pat.match(m_info[:date_time])
      date_time  = Time.new(dt[:year], dt[:month], dt[:day], dt[:hour], dt[:min])
      
      home_team = Team.find_or_create_by(title: m_info[:home_team])
      away_team = Team.find_or_create_by(title: m_info[:away_team])

      score_pat = SPORTS_RU_SCORE_PATTERN
      score = score_pat.match(m_info[:score])
      score_home, score_away = score[:home_score].to_i, score[:away_score].to_i if score.present?

      m = Match.new(date_time: date_time, home_team: home_team, away_team: away_team, score_home: score_home, score_away: score_away)
      if m.save 
        count_created += 1 
      else
        logger.info "#{m.errors.full_messages}\n"
      end
    end


    puts "Creating matches completed. IN: #{count_all}, SUCCESS: #{count_created}, ERRORS: #{count_all - count_created}"
    # добавить логи
  end

  def team_id(team_title)
    Team.find_or_create_by(title: team_title).id
    # team_titles = match_infos.map {|match| [match[:home_team], match[:away_team]]}.flatten.uniq
    # team_ids = team_titles.map { |title| { title => Team.find_or_create_by(title: title).id } }
  end

  def scrape_months_urls
    # в разных лигах sports.ru разный набор месяцев ; для простоты сохраняем набор месяцев , и пробегаемся по тем, которые находим
    # - они будут меняться и нужно будет вручную обновлять эти значения


  end
end

=begin

> matches =  doc.css('tbody')

  <tbody> 

    <tr>

> matches[0].css('td')[0].text #=> "\n\n01.11.2021|23:00\n"                        /(?<day>\d{2})\.(?<month>\d{2})\.(?<year>\d{4})\|(?<hour>\d{2})\:(?<min>\d{2})/
      <td class="name-td alLeft"> 
        <a href="/football/match/2021-11-01/">01.11.2021<span class="sp">|</span>23:00</a>                          # Дата и время
      </td>

> matches[0].css('td.owner-id')[1].text #=> "Вулверхэмптон"
      <td class="owner-td">
        <div class="rel">
          <i class="fader"></i>
          <i class="icon-flag icon-flag_1413 flag-s flag-1413" title="Англия"></i>                          
          <a class="player" href="https://www.sports.ru/wolves/" title="Вулверхэмптон">Вулверхэмптон</a>            # Командна - Хозяева
        </div>
      </td>

> matches[0].css('td')[2].text # => "2 : 1"                                       /(?<home>\d+).\:.(?<away>\d+)/
      <td class="score-td">
        <a class="score" href="https://www.sports.ru/football/match/1512233/"><noindex><b>2 : 1</b></noindex></a>   # Счет
      </td>

> matches[0].css('td')[3].text #=> "Эвертон"
      <td class="guests-td">
        <div class="rel">
          <i class="fader"></i>
          <i class="icon-flag icon-flag_1413 flag-s flag-1413" title="Англия"></i>
          <a class="player" href="https://www.sports.ru/everton/" title="Эвертон">Эвертон</a>                       # Команда - Гости
        </div>
      </td>

      <td class="padR alRight">-</td>

    </tr>
        
  </tbody>

=end