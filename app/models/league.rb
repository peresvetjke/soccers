class League < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true
end
