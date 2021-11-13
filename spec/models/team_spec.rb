require 'rails_helper'
require 'pry'

class MatchesScrapperDouble
  def record(args)
    { home_team: args["home_team"], away_team: args["away_team"] }
  end
end

RSpec.describe Team, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title)}
    # it { should validate_presence_of(:country)}

    describe 'uniqueness of title' do
      it { should validate_uniqueness_of(:title) }

      it "is not valid when same team_alias title exists" do
        existing_alias = create(:team_alias, title: "Team" )
        expect { create(:team, title: existing_alias.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title already exists in of team aliases."
      end
    end

    describe 'associations' do
      # it { should belong_to(:country) }
      it { should have_many(:team_aliases) }
    end
  end  
end