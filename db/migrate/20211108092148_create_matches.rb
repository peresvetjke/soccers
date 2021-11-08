class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :home_team, null: false, foreign_key: {to_table: :teams}
      t.references :away_team, null: false, foreign_key: {to_table: :teams}
      t.datetime :date_time, null: false
      t.integer :score_home
      t.integer :score_away

      t.timestamps
    end
  end
end
