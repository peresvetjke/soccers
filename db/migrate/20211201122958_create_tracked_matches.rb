class CreateTrackedMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :tracked_matches do |t|
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
