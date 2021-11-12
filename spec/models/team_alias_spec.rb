require 'rails_helper'

RSpec.describe TeamAlias, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    
    describe 'uniqueness of title' do
      it "is not valid when team_alias matches some team title" do
        existing_team = create(:team)
        expect { FactoryBot.create(:team_alias, title: existing_team.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title already exists in of team description."# ActiveRecord::RecordInvalid, "Validation failed: Title has already been taken"
      end
      
      subject { create(:team_alias) }
      it { should validate_uniqueness_of(:title) }
    end
  end

  describe "associations" do
    it { should belong_to(:team) }
  end

end