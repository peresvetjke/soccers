require "rails_helper"
require 'pry'

class MatchesScrapperDouble

  def matches_initial
    [
      {:date_time=>Time.new(2021,11,02,20,45), :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>nil, :score_away=>nil}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>nil, :score_away=>nil}
    ]
  end

  def matches_updated
    [
      {:date_time=>Time.new(2021,11,02,20,45), :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      # score updated in two lines up to initial:
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>2, :score_away=>3}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>3, :score_away=>4}
    ]
  end

  def matches_new
    [
      {:date_time=>Time.new(2021,11,02,20,45), :home_team=> "Вольфсбург", :away_team=> "Ред Булл", :score_home=>2, :score_away=>1}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Атлетико", :away_team=> "Милан", :score_home=>nil, :score_away=>nil}, 
      {:date_time=>Time.new(2021,11,24,23,00), :home_team=> "Ливерпуль", :away_team=> "Порту", :score_home=>nil, :score_away=>nil},
      # two new lines up to initial:
      {:date_time=>Time.new(2021,11,02,20,45), :home_team=> "Мальме", :away_team=> "Челси", :score_home=>0, :score_away=>1}, 
      {:date_time=>Time.new(2021,11,02,23,00), :home_team=> "Динамо Киев", :away_team=> "Барселона", :score_home=>nil, :score_away=>nil},
    ]
  end
end

RSpec.describe MatchesParser do
  let(:ms)         { MatchesScrapperDouble.new }
  let(:mp_initial) { MatchesParser.new(ms.matches_initial).call }
  let(:mp_updated) { MatchesParser.new(ms.matches_updated).call }
  let(:mp_new)     { MatchesParser.new(ms.matches_new).call }

  describe "#call" do
    context "when database is blank and matches data comes" do
      it "creates teams" do
        expect { mp_initial }.to change(Team, :count).by(ms.matches_initial.size * 2)
      end

      it "creates matches" do
        expect { mp_initial }.to change(Match, :count).by(ms.matches_initial.size)
      end

      it "returns new teams ids" do
        expect( mp_initial[:created_teams] ).to match_array(Team.all.ids)
      end

      it "returns new matches ids" do
        expect( mp_initial[:created_matches] ).to match_array(Match.all.ids)
      end

      it "writing score in db" do
        expect( Match.where(id: mp_initial[:created_matches]).all?{ |m| m.score_home.nil? && m.score_away.nil? } ).to be false
      end
    end

    context "when matches exist in db and its new score data comes" do
      before { 
        mp_initial 
        mp_updated
      }

      it "doesn't create matches" do
        expect { mp_initial }.to change(Match, :count).by(0) 
      end
      
      it "updates matches score" do
        expect( Match.pluck(:score_home, :score_away).any? { nil } ).to be false
      end

      it "returns zero new matches ids" do
        expect( mp_updated[:created_matches].count ).to eq(0)
      end

      it "returns updated matches ids" do
        expect( mp_updated[:updated_matches].count ).to eq(2)
      end

      it "writing score in db" do
        expect( Match.where(id: mp_initial[:created_matches]).any?{ |m| m.score_home.nil? && m.score_away.nil? } ).to be false
      end
    end
    
    context "when some matches exist and some matches are new" do
      before { mp_initial }

      it "doesn't create matches" do
        expect { mp_new }.to change(Match, :count).by(2)  
      end

      it "returns new matches ids" do
        expect( mp_new[:created_matches].size ).to eq(2)
      end

      it "returns zero updated matches count" do
        expect( mp_new[:updated_matches].size ).to eq(0)
      end
    end
  end
end