class TeamAlias < ApplicationRecord
  belongs_to :team

  validates :title, presence: true
  validates :title, uniqueness: true
  # validate that there is only one default=true alias for a team
  validate :validate_title_alias_uniqueness

  def self.find_team_by_title(title)
    team_alias = TeamAlias.find_by(title: title)
    team_alias&.team
  end

  private

  def validate_title_alias_uniqueness
    if Team.where(title: self.title).present?
      self.errors.add :title, message: "already exists in of team description."
    end
  end
end
