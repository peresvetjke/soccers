require 'rails_helper'

RSpec.describe TeamAlias, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }# it "is not valid without title"
    
    describe 'uniqueness of title' do
      let (:existing_team) { FactoryBot.create(:team, title: "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" ) }
      it "is not valid when team_alias matches some team title" do
        expect { FactoryBot.create(:team_alias, title: existing_team.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title already exists in of team description."# ActiveRecord::RecordInvalid, "Validation failed: Title has already been taken"
      end
      
      let (:existing_alias) { FactoryBot.create(:team_alias, title: "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" )}
      it "is not valid when team_alias already exists" do
        expect { FactoryBot.create(:team_alias, title: existing_alias.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title has already been taken"
      end
    end
  end

  describe "associations" do
    it { should belong_to(:team) }
  end

end