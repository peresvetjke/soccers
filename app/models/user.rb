class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites
  has_many :favorite_teams, through: :favorites, source: :team

  has_many :tracked_matches
  has_many :tracked_matches, through: :tracked_matches, source: :match
end
