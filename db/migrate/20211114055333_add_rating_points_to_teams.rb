class AddRatingPointsToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :rating_points, :integer
  end
end
