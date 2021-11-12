require 'rails_helper'

class MatchesScrapperDouble
  def record(args)
    { home_team_id: args["home_team_id"], away_team_id: args["away_team_id"], date_time: args["date_time"], score_home: args["score_home"], score_away: args["score_away"] }
  end
end

RSpec.describe Match, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date_time) }# it "is not valid without title"
  end

  describe 'associations' do
    # it { should have_many(:teams) }
    it { should belong_to(:home_team) }
    it { should belong_to(:away_team) }
  end

  describe 'instance methods' do
    let(:team_one) { create(:team) }
    let(:team_two) { create(:team) }
    let(:ms) { MatchesScrapperDouble.new }

    describe '#accept!' do

      context "when match doesn't exist" do

        it "creates new match in db" do
          #team_one
          #team_two
          match = build(:match, home_team: team_one, away_team: team_two)
          expect { Match.accept!(ms.record(match.attributes)) }.to change(Match, :count).by(1)
        end
      end

      context "when match exists" do
        context "when score is up-to-date"
        context "when score needs updating"
      end
    end
  end
end
