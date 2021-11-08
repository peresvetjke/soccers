class Country < ApplicationRecord
  has_many :teams

  validates :title, presence: true, uniqueness: true
end
