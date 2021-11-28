class Team < ApplicationRecord
  belongs_to  :country, optional: true
  has_many    :team_aliases

  validates :title, presence: true
  validates :title, uniqueness: true
  validate  :validate_title_uniqueness

  scope :top, -> (rating) { where('rating <= ?', rating) }

  def add_to_favorites!(user)
    raise ArgumentError, "Already added to favorites" if self.favorite?(user)
    user.favorite_teams.push(self)
  end

  def remove_from_favorites!(user)
    raise ArgumentError, "Not found in favorites" unless self.favorite?(user)
    Favorite.destroy(favorite(user).id)
  end 

  def favorite?(user)
    favorite(user).present?
  end

  private

  def favorite(user)
    Favorite.find_by(team_id: self.id, user_id: user.id)
  end

  def validate_title_uniqueness
    self.errors.add :title, message: "already exists in of team aliases." if TeamAlias.where(title: self.title).present?
  end
end
