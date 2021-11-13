class CreateTeamAliases < ActiveRecord::Migration[6.1]
  def change
    create_table :team_aliases do |t|
      t.references :team, null: false, foreign_key: true
      t.text :title
      t.boolean :default

      t.timestamps
    end
  end
end
