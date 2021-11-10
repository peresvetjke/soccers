module MatchesScrapMacros
  def scrap_matches(html_file_path: html_file_path)
    @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/1_sports_ru_matches_test_html_with_score"
    wps = WebPagesScrapper.new(html_file_path: html_file_path)
    ms = MatchesScrapper.new(web_pages_scrapper: @wps)
  end
end
