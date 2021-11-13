require "rails_helper"
require 'pry'

class RatingsScrapperDouble

  def ratings_initial
    [
      {:title=>"Манчестер Юн.",  :rating=>9},
      {:title=>"Аталанта",       :rating=>24}
    ]
  end

  def ratings_updated
    [
      {:title=>"Манчестер Юн.",  :rating=>9},
      # one line updated
      {:title=>"Аталанта",       :rating=>13}
    ]
  end

  def ratings_new
    [
      {:title=>"Манчестер Юн.",  :rating=>9},
      {:title=>"Аталанта",       :rating=>24},
      # one line added
      {:title=>"Манчестер Сити", :rating=>10}
    ]
  end
end

RSpec.describe RatingsParser do
  let(:rs)                 { RatingsScrapperDouble.new }
  let(:rp_initial)         { RatingsParser.new(rs.ratings_initial).call }
  let(:rp_updated)         { RatingsParser.new(rs.ratings_updated).call }
  let(:rp_new)             { RatingsParser.new(rs.ratings_new).call }
  let!(:existing_team_one) { create(:team, title: "Аталанта") }
  let!(:existing_team_two) { create(:team, title: "Манчестер Сити") }

  describe "#call" do
    context "when database is blank and ratings data comes" do
      let!(:result) { rp_initial }

      it "saves ratings" do
        expect(existing_team_one.reload.rating).to eq(24)
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

      it "returns team titles with ratings saved" do
        expect(rp_new[:updated]).to match_array(["Манчестер Сити"])
      end      

      it "returns team titles not found" do
        expect(rp_new[:not_found]).to match_array(["Манчестер Юн."])
      end
    end
  end
end