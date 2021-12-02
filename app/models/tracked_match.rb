class TrackedMatch < ApplicationRecord
  belongs_to :match
  belongs_to :user

  validates :user, uniqueness: { scope: :match_id, message: "already tracking this match." }
end