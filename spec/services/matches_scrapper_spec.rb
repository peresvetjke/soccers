require 'rails_helper'

class SportRuDouble

  def return_matches_initial
    [
      {:date_time=>2021-11-02 20:45:00 +0300, :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>nil, :score_away=>nil}, 
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>nil, :score_away=>nil}
    ]
  end

  def return_matches_updated
    [
      {:date_time=>2021-11-02 20:45:00 +0300, :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      # score updated in two lines up to initial:
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>2, :score_away=>3}, 
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>3, :score_away=>4}
    ]
  end

  def return_matches_added
    [
      {:date_time=>2021-11-02 20:45:00 +0300, :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>nil, :score_away=>nil}, 
      {:date_time=>2021-11-24 23:00:00 +0300, :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>nil, :score_away=>nil}
      # two new lines up to initial:
      {:date_time=>2021-11-02 20:45:00 +0300, :home_team=> "Мальме", :away_team=> "Челси", :score_home=>0, :score_away=>1}, 
      {:date_time=>2021-11-02 23:00:00 +0300, :home_team=> "Динамо Киев", :away_team=> "Барселона", :score_home=>nil, :score_away=>nil},
    ]
  end
end

RSpec.describe MatchesScrapper do
  describe ""
end


=begin
- перевести методы в модель
- добавить тесты на ключевые методы сервиса


RSpec.describe MatchesScrapper do
  describe "#teams" do
    before(:each) do
      @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/1_sports_ru_matches_test_html_with_score"
      @wps = WebPagesScrapper.new(html_file_path: @html_file_path)
      @ms = MatchesScrapper.new(web_pages_scrapper: @wps)
    end
    
    context "when team doesn't exist" do
      it "creates a new team in db" do
        expect { @ms.call }.to change(Team, :count).by(2)
      end
    end

    context "when team exists" do
      #let! (:team_one) { create(:team, title: "Вольфсбург") }
      #let! (:team_two) { create(:team, title: "Ред Булл") }

      it "doesn't create a new team in db" do
        expect { @ms.call }.not_to change(Team, :count)
      end
    end    
  end

  describe "#matches" do
    context "when match doesn't exist" do
      before(:context) do
        @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/1_sports_ru_matches_test_html_with_score"
        @wps = WebPagesScrapper.new(html_file_path: @html_file_path)
        @ms = MatchesScrapper.new(web_pages_scrapper: @wps)
      end

      it "creates new record" do
        expect { @ms.call }.to change(Match, :count).by(1)
      end
    end

    context "when match exists" do
     before(:context) do
        @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/1_sports_ru_matches_test_html_with_score"
        @wps = WebPagesScrapper.new(html_file_path: @html_file_path)
        @ms = MatchesScrapper.new(web_pages_scrapper: @wps)
      end

      #let! (:team_one) { create(:team, title: "Вольфсбург") }
      #let! (:team_two) { create(:team, title: "Ред Булл") }
      # let! (:match_one) { create(:match, home_team_id: team_one.id, away_team_id: team_two.id, date_time: Time.new(2021,11,05,17,00)) }

      it "doesn't create record" do
        expect { @ms.call }.not_to change(Match, :count)
      end

      context "when score is blank on site" do
        before(:context) do
          @team_one = create(:team, title: "Вольфсбург") 
          @team_two = create(:team, title: "Ред Булл") 
          @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/2_sports_ru_matches_test_html_without_score"
          @wps = WebPagesScrapper.new(html_file_path: @html_file_path)
          @ms = MatchesScrapper.new(web_pages_scrapper: @wps)
          @match_one = create(:match, home_team_id: @team_one.id, away_team_id: @team_two.id, date_time: Time.new(2021,11,05,17,00))
          @updated_at_before = @match_one.updated_at
        end

        it "doesn't update record" do
          @ms.call 
          expect(match_one.reload.updated_at).to eq(@updated_at_before)
        end
      end

      context "when score is filled on site" do
          #let! (:team_one) { create(:team, title: "Вольфсбург") }
          #let! (:team_two) { create(:team, title: "Ред Булл") }

        before(:context) do
          @html_file_path = "/home/i/workspace/repo/soccers/spec/services/html_test_cases/1_sports_ru_matches_test_html_with_score"
          @wps = WebPagesScrapper.new(html_file_path: @html_file_path)
          @ms = MatchesScrapper.new(web_pages_scrapper: @wps)
        end

        context "when score saved already in db" do
          let! (:match_one) { create(:match, home_team_id: team_one.id, away_team_id: team_two.id, date_time: Time.new(2021,11,05,17,00), score_home: 2, score_away: 1) }
          let! (:updated_at_before) { match_one.updated_at }
          it "doesn't update record" do
            
            @ms.call 
            expect(match_one.reload.updated_at).to eq(match_one.updated_at)
          end
        end

        context "when score is blank in db" do
          let! (:match_one) { create(:match, home_team_id: team_one.id, away_team_id: team_two.id, date_time: Time.new(2021,11,05,17,00), score_home: nil, score_away: nil) }

          it "updates score in db" do
            @ms.call 
            expect(match_one.reload.score_home).to eq(2)
          end
          
        end
      end
    end
  end
end
=end