class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.integer  :home_team_id, null: false
      t.integer  :away_team_id, null: false
      t.datetime :date_time, null: false
      t.integer  :score_home
      t.integer  :score_away

      t.timestamps
    end
  end
end
