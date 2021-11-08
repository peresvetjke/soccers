require 'rails_helper'

RSpec.describe Country, type: :model do
  describe "validations" do
    
    it "is not valid without title" do
      expect { FactoryBot.create(:country, title: nil) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title can't be blank" 
    end

    describe "uniqueness" do
      let (:existing_country) { FactoryBot.create(:country, title: "#{Array.new(10) { ('a'..'z').to_a[rand(1..26)]}.join}" )}
      it "is not valid when title already exists" do
        expect { FactoryBot.create(:country, title: existing_country.title) }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: Title has already been taken"
      end
    end
  end

end
