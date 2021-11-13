class Country < ApplicationRecord
  has_many :teams, dependent: :destroy

  validates :title, presence: true, uniqueness: true
end
