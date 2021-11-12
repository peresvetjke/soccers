require 'rails_helper'
require 'pry'

class MatchesScrapperDouble
  def record(args)
    { home_team_id: args["home_team_id"], away_team_id: args["away_team_id"], date_time: args["date_time"], score_home: args["score_home"], score_away: args["score_away"] }
  end
end

RSpec.describe Match, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date_time) }
  end

  describe 'associations' do
    # it { should have_many(:teams) }
    it { should belong_to(:home_team) }
    it { should belong_to(:away_team) }
  end

  describe 'instance methods' do
    let(:ms) { MatchesScrapperDouble.new }

    describe '#accept!' do

      context "when match doesn't exist" do

        it "creates new match in db" do
          match = build(:match)
          expect { Match.accept!(ms.record(match.attributes)) }.to change(Match, :count).by(1)
        end
      end

      context "when match exists" do
        
        context "when incoming record has no score" do
          it "doesn't update the record" do
            match = create(:match, score_home: nil, score_away: nil)
            Match.accept!(ms.record(match.attributes))
            expect(match.reload.score_home).to eq(nil)
            expect(match.reload.score_away).to eq(nil)
          end
        end

        context "when incoming record has score" do
        
          context "when score is up-to-date" do
            
            it "doesn't update the record" do
              match = create(:match, score_home: 1, score_away: 2)
              Match.accept!(ms.record(match.attributes))
              expect(match.reload.score_home).to eq(1)
              expect(match.reload.score_away).to eq(2)
            end
          end

          context "when score is blank in db" do
            it "updates the score in record" do
              match_without_score = create(:match, score_home: nil, score_away: nil)
              Match.accept!(ms.record(match_without_score.attributes.merge({"score_home" => 1, "score_away" => 2})))
              expect(match_without_score.reload.score_home).to eq(1)
              expect(match_without_score.reload.score_away).to eq(2)
            end
          end

          context "when score exists in db and needs updating" do
            it "updates the score in record" do
              match = create(:match, score_home: 1, score_away: 2)
              Match.accept!(ms.record(match.attributes.merge({"score_home" => 3, "score_away" => 4})))
              expect(match.reload.score_home).to eq(3)
              expect(match.reload.score_away).to eq(4)
            end
          end
        end
      end
    end
  end
end
