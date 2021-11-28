require "rails_helper"
require 'pry'

class RatingsScrapperDouble

  def ratings_initial
    [
      {:title=>"Манчестер Юн.",  :rating=>9,  :rating_points => 9000},
      {:title=>"Аталанта",       :rating=>24, :rating_points => 6000}
    ]
  end

  def ratings_updated
    [
      {:title=>"Манчестер Юн.",  :rating=>9,  :rating_points => 9000},
      # one line updated
      {:title=>"Аталанта",       :rating=>13, :rating_points => 8000}
    ]
  end

  def ratings_new
    [
      {:title=>"Манчестер Юн.",  :rating=>9,  :rating_points => 9000},
      {:title=>"Аталанта",       :rating=>24, :rating_points => 6000},
      # one line added
      {:title=>"Манчестер Сити", :rating=>10, :rating_points => 8500}
    ]
  end
end

RSpec.describe RatingsParser do
  let(:rs)                   { RatingsScrapperDouble.new }
  let(:rp_initial)           { RatingsParser.new(rs.ratings_initial).call }
  let(:rp_updated)           { RatingsParser.new(rs.ratings_updated).call }
  let(:rp_new)               { RatingsParser.new(rs.ratings_new).call }
  let!(:existing_team_one)   { create(:team, title: "Аталанта") }
  let!(:existing_team_two)   { create(:team, title: "Манчестер Сити") }

  describe "#call" do
    context "when database is blank and ratings data comes" do
      let!(:result) { rp_initial }

      it "saves ratings" do
        expect(existing_team_one.reload.rating).to eq(24)
      end

      it "saves rating_points" do
        expect(existing_team_one.reload.rating_points).to eq(6000)
      end

      it "returns team titles with ratings saved" do
        expect(result[:updated]).to match_array(["Аталанта"])
      end

      it "returns team titles not found" do
        expect(result[:not_found]).to match_array(["Манчестер Юн."])
      end
    end

    context "when ratings exist in db and new values come" do      
      before { rp_initial }

      it "updates rating" do
        rp_new
        expect(existing_team_two.reload.rating).to eq(10)
      end     

      it "updates rating points" do
        rp_new
        expect(existing_team_two.reload.rating_points).to eq(8500)
      end    

      it "returns team titles with ratings saved" do
        expect(rp_new[:updated]).to match_array(["Манчестер Сити"])
      end      

      it "returns team titles not found" do
        expect(rp_new[:not_found]).to match_array(["Манчестер Юн."])
      end
    end

    context "when team can't be found by its default title" do
      let!(:existing_team_three) { create(:team, title: "Манчестер Юнайтед") }

      context "when team alias for title exists" do        
        let!(:team_alias) { create(:team_alias, title: "Манчестер Юн.", team: existing_team_three) }
        let!(:result) { rp_initial }

        it "saves ratings and rating points" do
          expect(existing_team_three.reload.rating).to eq(9)
          expect(existing_team_three.reload.rating_points).to eq(9000)
        end

        it "returns team titles with ratings saved" do
          expect(result[:updated]).to match_array(["Манчестер Юнайтед", "Аталанта"])          
        end

        it "returns empty 'not found' team titles" do
          expect(result[:not_found]).to match_array([])
        end
      end

      context "when team alias doesn't exist" do
        let!(:result) { rp_initial }
        
        it "returns team titles not found" do
          expect(result[:not_found]).to match_array(["Манчестер Юн."])
        end
      end
    end
  end
end