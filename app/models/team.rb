class Team < ApplicationRecord
  belongs_to  :country, optional: true
  has_many    :team_aliases
  

  validates :title, presence: true
  # validates :country, presence: true
  validates :title, uniqueness: true
  validate  :validate_title_uniqueness

  def matches

  end

  def validate_title_uniqueness
    self.errors.add :title, message: "already exists in of team aliases." if TeamAlias.where(title: self.title).present?
  end

end
