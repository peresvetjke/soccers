require 'rails_helper'

RSpec.describe MatchesScrapper, type: :model do
  let(:raw_file) { File.read("/home/i/workspace/repo/soccers/spec/services/raw_html/sports_ru_matches") }
  # let!(:matches_scrapper) { MatchesScrapper.new(WebPagesScrapper.new) }
  # let!(:matches_web_page) { create(:matches_web_page) }
  let(:wps) { WebPagesScrapper.new(file: raw_file) }
  let(:ms)  { MatchesScrapper.new(wps) }

  describe "#teams" do

    context "when team doesn't exist" do
      it "creates a new team in db" do
        expect { ms.call }.to change(Team, :count).by(8)
      end
    end

    context "when team exists" do
      it "doesn't create a new team in db"
    end    
  end

  describe "#matches" do
    context "when match doesn't exist" do
      it "creates new record"
    end

    context "when match exists" do
      it "doesn't create record"

      context "when score is already maintained" do
        it "doesn't update record"
      end

      context "when score is blank" do
        it "adds score to match record"
      end
    end
  end
end
