require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title)}
    it { should validate_presence_of(:country)}

    describe 'uniqueness of title' do
      let (:existing_team) { FactoryBot.create(:team, title: "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" ) }
      let (:existing_alias) { FactoryBot.create(:team_alias, title: "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" )}
      it "is not valid when same team title exists" do
        expect { FactoryBot.create(:team, title: existing_team.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title has already been taken"
      end

      it "is not valid when same team_alias title exists" do
        expect { FactoryBot.create(:team, title: existing_alias.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title already exists in of team aliases."
      end
    end

    describe 'associations' do
      it { should belong_to(:country) }
      it { should have_many(:team_aliases) }
    end
  end  
end