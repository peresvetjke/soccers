class Team < ApplicationRecord
  belongs_to  :country, optional: true
  has_many    :team_aliases

  validates :title, presence: true
  validates :title, uniqueness: true
  validate  :validate_title_uniqueness

  def self.team_ids(args)
    home_team = self.find_or_create_by(title: args[:home_team])
    away_team = self.find_or_create_by(title: args[:away_team])
    { home_team_id: home_team.id, away_team_id: away_team.id }
  end

  private

  def validate_title_uniqueness
    self.errors.add :title, message: "already exists in of team aliases." if TeamAlias.where(title: self.title).present?
  end
end
