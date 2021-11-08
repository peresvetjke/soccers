require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date_time) }# it "is not valid without title"
  end

  describe 'associations' do
    # it { should have_many(:teams) }
    it { should belong_to(:home_team) }
    it { should belong_to(:away_team) }
  end
end
