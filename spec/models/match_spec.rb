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
    it { should belong_to(:league) }
  end
end
