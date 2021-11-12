require 'rails_helper'

RSpec.describe League, type: :model do
  
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end

end